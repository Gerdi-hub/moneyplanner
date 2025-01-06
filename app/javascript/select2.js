import "jquery"
import "select2"
import "select2.css"


document.addEventListener("DOMContentLoaded", function() {
    const selectElement = $('select[multiple]');
    if (selectElement.length) {
        selectElement.select2({
            placeholder: 'Select years',
            allowClear: true
        });
    }
});