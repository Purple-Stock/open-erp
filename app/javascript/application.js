// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Core libraries
import "@hotwired/turbo-rails";

require("./channels");
import "./controllers";

// Application
require("./app").start();

// jQuery (as a read only property so browser extensions can't clobber it)
const jquery = require("jquery");
window.$ = window.jQuery = jquery;

// App libraries
require("bootstrap");
require("jquery.nicescroll");

require("select2");
require("cleave.js");
require("waypoints/lib/noframework.waypoints");
require("waypoints/lib/shortcuts/infinite");
require("@nathanvda/cocoon");

window.iziToast = require("izitoast");

// Stisla
require("./vendors/stisla/stisla");
require("./vendors/stisla/scripts");

import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt";

flatpickr.localize(Portuguese); // default locale is now Portuguese

import Swal from "sweetalert2";

// Override setConfirmMethod on Turbo Rails with sweetalert2
Turbo.setConfirmMethod((message, element) => {
  return new Promise((resolve, reject) => {
    Swal.fire({
      title: message,
      text: "Você não poderá reverter isso!",
      icon: "warning",
      type: "warning",
      confirmButtonText: "OK",
      confirmButtonColor: "#2acbb3",
      cancelButtonText: "Cancelar",
      cancelButtonColor: "#d33",
      showCancelButton: true,
    }).then((result) => {
      if (result.isConfirmed) {
        Swal.fire("Removido!", "Dados removidos com sucesso.", "success");
        resolve(true);
        return true;
      }
    });
  });
});

document.addEventListener("turbo:load", () => {
  $("#list").select2();
  $(".select2-list").select2();
  flatpickr(".flatpick-input-date", {
    dateFormat: "d/m/Y",
    altInput: true,
    altFormat: "d/m/Y",
  });
  flatpickr(".flatpick-input-datetime", {
    dateFormat: "d/m/Y H:i",
    altInput: true,
    altFormat: "d/m/Y H:i",
  });
});
