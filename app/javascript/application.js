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

document.addEventListener('turbo:load', function() {
    // Initialize all collapsible elements
    var collapsibles = document.querySelectorAll('[data-bs-toggle="collapse"]');
    collapsibles.forEach(function(element) {
        new bootstrap.Collapse(element.dataset.bsTarget, {
            toggle: false
        });
    });
});