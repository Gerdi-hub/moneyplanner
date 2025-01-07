// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require bootstrap

import "jquery"

import "@hotwired/turbo-rails"
import "controllers"
import "select2"
import "./select2"
import "bootstrap"
import "chartkick"
import "Chart.bundle"

import Rails from "@rails/ujs";

Rails.start();

