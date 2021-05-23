/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/products.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/products.js":
/*!******************************************!*\
  !*** ./app/javascript/packs/products.js ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports) {

$(document).ready(function () {
  $('#product_category_id').select2();
  $('#product-ajax').dataTable({
    ajax: {
      url: '/products_defer',
      deferRender: true,
      dataSrc: function dataSrc(json) {
        json.recordsTotal = json.meta.recordsTotal;
        json.recordsFiltered = json.meta.recordsFiltered;
        return json.data;
      }
    },
    serverSide: true,
    columns: [{
      title: "Codigo Produto",
      data: 'attributes.custom_id'
    }, {
      title: "SKU",
      data: 'attributes.sku',
      "searchable": false,
      "orderable": false
    }, {
      title: "Foto",
      data: 'attributes.image_url',
      "orderable": false,
      "searchable": false,
      render: function render(image_url) {
        return '<img src="' + image_url + '"width="250px" height="163px">';
      }
    }, {
      title: "Preço",
      data: 'attributes.price',
      "searchable": false,
      "orderable": false
    }, {
      title: "Nome",
      data: 'attributes.name'
    }, {
      title: "Entrada",
      data: 'attributes.count_purchase_product',
      "orderable": false,
      "searchable": false
    }, {
      title: "Saída",
      data: 'attributes.count_sale_product',
      "orderable": false,
      "searchable": false
    }, {
      title: "Saldo",
      data: 'attributes.balance',
      "orderable": false,
      "searchable": false
    }, {
      title: "Categoria",
      data: 'attributes.category',
      "orderable": false,
      "searchable": false
    }, {
      title: "Ativo",
      data: 'attributes.active',
      "searchable": false,
      "orderable": false
    }, {
      title: "Ações",
      data: 'attributes.id',
      "searchable": false,
      "orderable": false,
      render: function render(id) {
        var html = '<a class="btn btn-default btn-xs" href="/products/' + id + '">Ver</a><a class="btn btn-default btn-xs" href="/products/' + id + '/edit">Editar</a><a data-confirm="Você tem certeza?" data-method="delete" rel="nofollow" class="btn btn-danger btn-xs" href="/products/' + id + '">Deletar</a>';
        html += '<a class="btn btn-default btn-xs" href="/products/' + id + '/duplicate">Duplicar</a>';
        return html;
      }
    }],
    "language": {
      "url": "https://cdn.datatables.net/plug-ins/1.10.12/i18n/Portuguese-Brasil.json"
    },
    columnDefs: [{
      type: 'formatted-num',
      targets: 0
    }],
    "order": [[0, "desc"]],
    responsive: true,
    stateSave: false
  });
});

/***/ })

/******/ });
//# sourceMappingURL=products-b99272a423a7012a2666.js.map