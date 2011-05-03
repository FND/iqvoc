/*jslint browser: true, unparam: true */
/*global jQuery, IQVOC */

IQVOC.LanguageSelector = (function($) {

var getSelection, setSelection;

// namespace is used for both localStorage and the event being triggered
var LanguageSelector = function(container, namespace) {
	this.container = container;
	this.namespace = namespace;
	this.langs = getSelection(namespace);
	this.checkboxes = $("input:checkbox", container)
			.live("change", this.onChange);

	$(container).addClass("widget").data("widget", this);
	this.init();
};
$.extend(LanguageSelector.prototype, {
	onChange: function(ev) {
		var el = $(this),
			widget = el.closest(".widget").data("widget");
		if(el.attr("checked")) {
			widget.add(el.val());
		} else {
			widget.remove(el.val());
		}
	},
	init: function() {
		if(this.langs === null) {
			this.langs = $.map(this.checkboxes, function(node, i) {
				return $(node).val();
			});
		}
		var self = this;
		this.checkboxes.each(function(i, node) {
			var el = $(node);
			if($.inArray(el.val(), self.langs) !== -1) {
				el.attr("checked", "checked");
			} else {
				el.removeAttr("checked");
			}
		});
		$(document).trigger(this.namespace, { langs: this.langs });
	},
	add: function(value) {
		if($.inArray(value, this.langs) === -1) {
			this.langs.push(value);
			setSelection(this.langs, this.namespace);
		}
	},
	remove: function(value) {
		var pos = $.inArray(value, this.langs);
		if(pos !== -1) {
			this.langs.splice(pos, 1);
			setSelection(this.langs, this.namespace);
		}
	}
});

getSelection = function(namespace) {
	var langs = localStorage.getItem(namespace);
	return langs === null ? null : (langs ? langs.split(",") : []);
};

setSelection = function(langs, namespace) {
	localStorage.setItem(namespace, langs.join(","));
	$(document).trigger(namespace, { langs: langs });
};

return LanguageSelector;

}(jQuery));
