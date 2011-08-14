DrawPoints = OpenLayers.Class(OpenLayers.Control.DrawFeature, {

    // this control is active by default
    autoActivate: true,

    initialize: function(layer, options) {
        // only points can be drawn
        var handler = OpenLayers.Handler.Point;
        OpenLayers.Control.DrawFeature.prototype.initialize.apply(
				this, [layer, handler, options]
			);
    },

    drawFeature: function(geometry) {
        OpenLayers.Control.DrawFeature.prototype.drawFeature.apply(
				this, arguments	
			);
        if (this.layer.features.length == 1) {
            // we just draw the startpoint
            // note: if we want to apply a special style to the 
            //       start point we should do this here
        } else if (this.layer.features.length == 2) {
            // we just draw the finalpoint
            // note: if we want to apply a special style to the 
            //       final point we should do this here

            // we have all what we need; we can deactivate ourself.
            this.deactivate();            
        }
    }
});
