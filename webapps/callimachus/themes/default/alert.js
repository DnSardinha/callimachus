// alert.js

(function($){

$(document).error(function(event) {
	var status = event.message;
	var detail = event.data;
	if (status) {
		var msg = $("#errors");
		if (msg.size()) {
			var widget = $('<div/>');
			widget.addClass("ui-state-error ui-corner-all");
			widget.css("padding", "1ex");
			widget.css("margin", "1ex");
			var p = $('<div/>');
			var icon = $('<span/>');
			icon.addClass("ui-icon ui-icon-alert");
			icon.css("margin-right", "0.3em");
			icon.css("float", "left");
			var close = $('<span/>');
			close.addClass("ui-icon ui-icon-close");
			var button = $('<span/>');
			button.css("display", "block");
			button.css("float", "right");
			button.click(function() {
				widget.remove();
			});
			button.append(close);
			var strong = $('<strong/>');
			strong.css("margin-right", "0.7em");
			strong.text("Alert:");
			p.append(icon);
			p.append(button);
			p.append(strong);
			p.append(status);
			widget.append(p);
			if (detail) {
				var pre = $("<pre/>");
				pre.text(detail);
				pre.hide();
				widget.append(pre);
				p.click(function() {
					pre.toggle();
				});
			}
			msg.append(widget);
			scroll(0,0);
		} else {
			alert(status);
		}
	}
});

})(window.jQuery);

