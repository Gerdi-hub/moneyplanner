import "jquery"
import "select2"


document.addEventListener("DOMContentLoaded", function() {
    const selectElement = $('select[multiple]');
    if (selectElement.length) {
        selectElement.select2({
            placeholder: 'Select years',
            allowClear: true
        });
    }
});