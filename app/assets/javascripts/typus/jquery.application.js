$(document).ready(function() {

    $("#quicksearch").searchField();

    $('.resource :input', document.myForm).bind("change", function() { setConfirmUnload(true); });

    $("a.fancybox").fancybox({
        'titlePosition': 'over',
        'type': 'image',
        'centerOnScroll': true,
        'scrolling': false,
    });

    $(".iframe_with_form_reload").fancybox({
        'width': 720,
        'height': '90%',
        'autoScale': false,
        'transitionIn': 'none',
        'transitionOut': 'none',
        'type': 'iframe',
        'centerOnScroll': true,
        'scrolling': false,
        onClosed: function() {
            var attribute = Typus.resource_attribute;
            var text = Typus.resource_to_label;
            var value = Typus.resource_id;
            $(attribute).append(new Option(text, value, true, true));
            $(".chzn-select").trigger("liszt:updated");
        },
    });

    $(".iframe").fancybox({
        'width': 720,
        'height': '90%',
        'autoScale': false,
        'transitionIn': 'none',
        'transitionOut': 'none',
        'type': 'iframe',
        'centerOnScroll': true,
        'scrolling': false,
        onClosed: function() {
            if (Typus.parent_location_reload)
                parent.location.reload(true);
        },
    });

    // This method is used by Typus::Controller::Bulk
    $(".action-toggle").click(function() {
        var status = this.checked;
        $('input.action-select').each(function() { this.checked = status; });
        $('.action-toggle').each(function() { this.checked = status; });
    });

    $(".chzn-select").chosen();

});

Typus = {}

function setConfirmUnload(on) {
    window.onbeforeunload = (on) ? unloadMessage : null;
}

function unloadMessage() {
    return "You have entered new data on this page. If you navigate away from this page without first saving your data, the changes will be lost.";
}
