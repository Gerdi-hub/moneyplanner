// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery"

import "@hotwired/turbo-rails"
import "controllers"
import "select2"
import "./select2"
import "@popperjs/core"
import "bootstrap"
import "chartkick"
import "Chart.bundle"

import Rails from "@rails/ujs";

Rails.start();

console.log("APPLICATION.JS LOADED");

document.addEventListener('turbo:load', function() {
    var collapsibles = document.querySelectorAll('[data-bs-toggle="collapse"]');
    collapsibles.forEach(function(element) {
        new bootstrap.Collapse(element.dataset.bsTarget, {
            toggle: false
        });
    });
});


document.addEventListener('turbo:load', function () {
    document.querySelectorAll('input[type="checkbox"][id^="select_all_year_"]').forEach(function (yearCheckbox) {
        yearCheckbox.addEventListener('change', function () {
            const year = this.getAttribute('data-year');
            const isChecked = this.checked;
            console.log('Checkbox for year ' + year + ' is ' + (isChecked ? 'checked' : 'unchecked'));
            document.querySelectorAll(`#year${year} .month-checkbox`).forEach(function (monthCheckbox) {
                monthCheckbox.checked = isChecked;
            });
        });
    });
});


document.addEventListener("turbo:load", function () {
    const notice = document.getElementById("notice");
    if (notice) {
        setTimeout(() => {
            notice.style.transition = "opacity 2s ease-out";
            notice.style.opacity = 0;
            setTimeout(() => notice.remove(), 2000);
        }, 5000);
    }
});