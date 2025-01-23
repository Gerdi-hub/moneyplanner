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


document.addEventListener('DOMContentLoaded', function () {
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

console.error("APPLICATION.JS LOADED DEFINITIVELY");
window.globalTestFunction = function() {
    console.error("GLOBAL TEST FUNCTION CALLED");
    alert("Definitive JavaScript Test");
};