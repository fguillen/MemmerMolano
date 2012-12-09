var VideoExtrasApp;

$(function(){
  VideoExtrasApp = function( opts ){
    console.debug( "[VideoExtrasApp] initializing ..." );

    this.url                    = opts.url;
    this.listElement            = opts.listElement;
    this.videoTemplate          = opts.videoTemplate;
    this.newVideoElement        = opts.newVideoElement;

    this.initialize = function( opts ){
      this.videos = new VideoExtrasApp.Videos({
        url: this.url
      });

      this.videosView = new VideoExtrasApp.VideosView({
        reorderUrl: this.url + "/reorder",
        collection: this.videos,
        videoTemplate: this.videoTemplate,
      });

      this.newVideoVideo = new VideoExtrasApp.NewVideoView({
        el: this.newVideoElement,
        url: this.url,
        collection: this.videos
      });

      $(this.listElement).append( this.videosView.render().el );

      this.videos.fetch();
    }

    this.initialize( opts );
  };

  VideoExtrasApp.Video = Backbone.Model.extend({
    initialize: function(){
      _.bindAll( this, "onProgress", "onSuccess", "onError" );
      if( !this.get( "state" ) ) this.set( "state", "completed" );
    },

    upload: function() {
      console.debug( "[BBAssetsUpload 0.0.3] Uploading file: " + this.get( "file" ).name );

      $.upload(
        this.get( "url" ),
        this.get( "file" ),
        {
          upload:   { progress: this.onProgress },
          success:  this.onSuccess,
          error:    this.onError
        }
      );
    },

    onStart: function(){
      if( this.eventCatcher ) this.eventCatcher.trigger( "asset:start", this );
    },

    onProgress: function( event ){
      var progress = Math.round((event.position / event.total) * 100);
      var opts = { "progress": progress };
      if( progress == 100 ) opts["state"] = "processing";
      this.set( opts );
      if( this.eventCatcher ) this.eventCatcher.trigger( "asset:progress", this );
    },

    onSuccess: function( event ){
      console.debug( "[BBAssetsUpload 0.0.3] File uploaded: " + this.get( "file" ).name );
      var opts = _.extend( event, { "state": "completed" } );
      this.set( opts );
      if( this.eventCatcher ) this.eventCatcher.trigger( "asset:success", this );
    },

    onError: function( event ){
      console.error( "[BBAssetsUpload 0.0.3] onError uploading file: " + this.get( "file" ).name, event );
      if( this.eventCatcher ) this.eventCatcher.trigger( "asset:error", this );
    }
  });

  VideoExtrasApp.Videos = Backbone.Collection.extend({
    model: VideoExtrasApp.Video,

    initialize: function( options ){
      this.url = options.url;
    },
  });

  VideoExtrasApp.VideoView = Backbone.View.extend({
    tagName: "li",

    attributes: {
      class: "video_item span6"
    },

    initialize: function(){
      console.log( "this.options.template", this.options.template );
      this.template = _.template( this.options.template );

      this.model.on( "destroy", this.remove, this );
      this.model.on( "change", this.render, this );
    },

    events: {
      "click .delete": "destroy"
    },

    destroy: function(){
      this.model.destroy();
    },

    render: function() {
      console.log( "this.model.toJSON", this.model.toJSON() );
      this.$el.html( this.template( this.model.toJSON() ) );
      this.$el.attr( "data-id", this.model.id );
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
        placeholder : "placeholder",
        update      : $.proxy( this.updateOrder, this ),
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

  VideoExtrasApp.NewVideoView = Backbone.View.extend({
    events: {
      "click .submit": "createVideo"
    },

    initialize: function(){
      _.bindAll( this, "parseResponse" );
      console.log( "NewVideoView", this.$el );
    },

    createVideo: function( event ){
      event.preventDefault();

      console.log( "NewVideoView.createVideo" );

      this.$el.find( "#video_new_errors" ).fadeOut();
      this.$el.find( "#video_new_errors ul" ).empty();

      var formData = new FormData(this.$el.find('form')[0]);

      $.ajax({
        url: this.options.url,
        type: "POST",
        beforeSend: function(){ console.log( "beforeSend" ) },
        success:  this.parseResponse,
        error:  function( error ){ console.log( "error", error ) },
        data: formData,
        cache: false,
        contentType: false,
        processData: false
      });
    },

    parseResponse: function( data ){
      console.log( "parseResponse", data );
      var _self = this;

      console.log( "parseResponse.el", this.$el );

      if( data.errors ) {
        _.each(data.errors, function( error ){
          _self.$el.find( "#video_new_errors ul" ).append( "<li>" +  error + "</li>" );
        });

        this.$el.find( "#video_new_errors" ).fadeIn();
      } else {
        var video = new VideoExtrasApp.Video( data )
        this.options.collection.add( video );
      }
    }

  }),

  VideoExtrasApp.VideosOrder = Backbone.Model.extend({
    initialize: function( options ){
      this.url = options.url
    }
  });
});