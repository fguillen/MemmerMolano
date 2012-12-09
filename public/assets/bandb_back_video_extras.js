var VideoExtrasApp;

$(function(){
  VideoExtrasApp = function( opts ){
    console.debug( "[VideoExtrasApp] initializing ..." );

    this.url                    = opts.url;
    this.listElement            = opts.listElement;
    this.videoTemplate          = opts.videoTemplate;
    this.videoFormElement        = opts.videoFormElement;

    this.initialize = function( opts ){
      this.videos = new VideoExtrasApp.Videos({
        url: this.url
      });

      this.videosView = new VideoExtrasApp.VideosView({
        reorderUrl: this.url + "/reorder",
        collection: this.videos,
        videoTemplate: this.videoTemplate,
      });

      this.videoFormView = new VideoExtrasApp.VideoFormView({
        el: this.videoFormElement,
        url: this.url,
        collection: this.videos,
        model: new VideoExtrasApp.Video()
      });

      $(this.listElement).append( this.videosView.render().el );

      this.videos.fetch();
    }

    this.initialize( opts );
  };

  VideoExtrasApp.Video = Backbone.Model.extend({
    initialize: function(){
      if( !this.get( "state" ) ) this.set( "state", "completed" );
    },
  });

  VideoExtrasApp.Videos = Backbone.Collection.extend({
    model: VideoExtrasApp.Video,

    initialize: function( options ){
      this.url = options.url;
    },
  });

  VideoExtrasApp.VideoView = Backbone.View.extend({
    tagName: "li",

    events: {
      "click .delete": "destroy"
    },

    attributes: {
      class: "video_item span6"
    },

    initialize: function(){
      this.template = _.template( this.options.template );

      this.model.on( "destroy", this.remove, this );
      this.model.on( "change", this.render, this );
    },

    destroy: function(){
      this.model.destroy();
    },

    render: function() {
      console.log( "render this.model.toJSON()", this.model.toJSON() );

      this.$el.html( this.template( this.model.toJSON() ) );
      this.$el.attr( "data-id", this.model.id );
      this.$el.find("#video_form").attr( "id", "video_form_" + this.model.id );

      /* Activate VideoFormView */
      this.videoFormView = new VideoExtrasApp.VideoFormView({
        el: this.$el.find("#video_form_" + this.model.id ),
        url: this.model.url(),
        collection: this.model.collection,
        model: this.model
      });

      this.videoFormView.$el.find("#video_text").mdmagick();

      return this;
    }

  });

  VideoExtrasApp.VideosView = Backbone.View.extend({
    tagName: "ul",

    attributes: {
      class: "thumbnails"
    },

    initialize: function( options ){
      this.collection.on( "add",   this.addOne, this );
      this.collection.on( "reset", this.addAll, this );

      this.$el.sortable({
        update      : $.proxy( this.updateOrder, this ),
        handle      : ".handle"
      });

      this.$el.disableSelection();
    },

    updateOrder: function(){
      var sorted_ids =
        $.makeArray(
          this.$el.find( "li" ).map( function( element ){
            return $(this).attr( "data-id" );
          })
        );

      var asset_order = new VideoExtrasApp.VideosOrder({ url : this.options.reorderUrl });
      asset_order.save({ ids: sorted_ids })
    },

    addOne: function( model ) {
      var view = new VideoExtrasApp.VideoView({
        model: model,
        template: this.options.videoTemplate
      });

      this.$el.append( view.render().el );
      this.$el.sortable( "refresh" );
    },

    addAll: function() {
      this.collection.each( $.proxy( this.addOne, this ) );
    },
  });

  VideoExtrasApp.VideoFormView = Backbone.View.extend({
    events: {
      "click .submit": "sendData"
    },

    initialize: function(){
      _.bindAll( this, "parseResponse" );
      this.formAction = this.options.model.get("id") ? "PUT" : "POST"
      niceFileField(this.$el.find(".video_pic_field"));
      this.fillFormFields()
    },

    fillFormFields: function(){
      this.$el.find("#video_title").val( this.options.model.get("title") );
      this.$el.find("#video_script").val( this.options.model.get("script") );
      this.$el.find("#video_text").val( this.options.model.get("text") );

      if( this.options.model.get("id") ){
        this.$el.find(".video_form_label").html("Update Extra Video");
        this.$el.find(".submit").val("Update Extra Video");
      }
    },

    sendData: function( event ){
      event.preventDefault();
      this.$el.find( "#video_new_errors" ).hide();
      this.$el.find( "#video_new_errors ul" ).remove();

      var formData = new FormData(this.$el.find('form')[0]);

      $.ajax({
        url: this.options.url,
        type: this.formAction,
        success: this.parseResponse,
        error: function( error ){ console.error( "error", error ) },
        data: formData,
        cache: false,
        contentType: false,
        processData: false
      });
    },

    parseResponse: function( data ){
      console.log( "parseResponse", data );
      var _self = this;

      if( data.errors ) {
        this.$el.find( "#video_new_errors" ).append("<ul></ul>");

        _.each(data.errors, function( error ){
          _self.$el.find( "#video_new_errors ul" ).append( "<li>" +  error + "</li>" );
        });

        this.$el.find( "#video_new_errors" ).fadeIn();
      } else {
        this.$el.modal("hide");
        this.options.model.set( data );
        this.options.collection.add( this.options.model );
      }
    }

  }),

  VideoExtrasApp.VideosOrder = Backbone.Model.extend({
    initialize: function( options ){
      this.url = options.url
    }
  });
});