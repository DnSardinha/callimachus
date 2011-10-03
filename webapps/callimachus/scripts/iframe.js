// iframe.js

(function($) {

	function getPageLocationURL() {
		// window.location.href needlessly decodes URI-encoded characters in the URI path
		// https://bugs.webkit.org/show_bug.cgi?id=30225
		var path = location.pathname;
		if (path.match(/#/))
			return location.href.replace(path, path.replace('#', '%23'));
		return location.href;
	}

	function checkWindowSize() {
		var innerHeight = window.innerHeight || document.documentElement.clientHeight;
		if (innerHeight < document.height) {
			parent.postMessage('PUT height\n\n' + document.height, '*');
		} else {
			var scrollHeight = document.height;
			$('#content').add($('#content').parents()).each(function(){
				scrollHeight += this.scrollHeight - this.clientHeight;
			});
			if (scrollHeight > innerHeight) {
				parent.postMessage('PUT height\n\n' + scrollHeight, '*');
			}
		}
		var clientWidth = document.documentElement.clientWidth;
		if (clientWidth < document.documentElement.scrollWidth) {
			parent.postMessage('PUT width\n\n' + document.documentElement.scrollWidth, '*');
		} else {
			var scrollWidth = document.documentElement.scrollWidth;
			$('#content').add($('#content').parents()).each(function(){
				scrollWidth += this.scrollWidth - this.clientWidth;
			});
			if (scrollWidth > clientWidth) {
				parent.postMessage('PUT height\n\n' + scrollWidth, '*');
			}
		}
	}

	if (window.parent != window) {
		document.documentElement.className += " iframe";
		var src = null;
		var postSource = function() {
			if (window.location.search == '?view' && parent.postMessage) {
				var url = getPageLocationURL();
				if (url != src) {
					src = url;
					parent.postMessage('PUT src\n\n' + url, '*');
				}
			}
		}
		$(window).bind('popstate', postSource);
		$(postSource);
		$(window).bind('load resize', function() {
			setTimeout(checkWindowSize, 0);
		});
	}
})(jQuery);
