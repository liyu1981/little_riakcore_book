var util = require('util');
var jsdom = require('jsdom').env;
var jquery = require('jquery');
var async = require('async');

var rawfilepath = process.argv[2];

function runCmd(cmd, args, input, callback) {
  var spawn = require('child_process').spawn;
  var child = spawn(cmd, args);
  var out = '';
  var err = '';
  child.stdout.on('data', function(buffer) { out += buffer.toString(); });
  child.stderr.on('data', function(buffer) { err += buffer.toString(); });
  child.on('close', function(code) { callback(code, out, err); });
  child.stdin.write(input);
  child.stdin.end();
}

var header = '<!DOCTYPE html><html>';
var footer = '</html>';
var pygmentsCss = '<link rel="stylesheet" href="pygments.css" type="text/css">';

function formatCallout(id) {
  var parts = id.split('-');
  return util.format('<a id="%s"><img src="images/icons/callouts/%d.png" /></a>', id, parts[1]);
}

var handleCalloutLinks = (function() {
  var re = /\[link\[coid#(.+)\]\]/g;
  return function _replace(out, callback) {
    var r = re.exec(out);
    if (r) {
      var newout = out.substring(0, r.index) + formatCallout(r[1]);
      re.lastIndex = newout.length;
      newout += out.substring(r.index + r[0].length);
      _replace(newout, callback);
    } else {
      re.lastIndex = 0;
      callback(out);
    }
  };
})();

var highlightCode = function($, next) {
  var $t = $('pre.programlisting');
  async.mapSeries($t.toArray(), function(elem, next) {
    var $c = $(elem);
    var language = $c.data('language');
    var code = $c.text();
    //console.log(code + '\n\n');
    runCmd('pygmentize', ['-f', 'html', '-l', language], code, function(code, out, err) {
      if (code === 0) {
        // now handle the callout links
        handleCalloutLinks(out, function(out) {
          //console.log(out + '\n\n');
          $c.replaceWith(out);
        });
      } else {
        console.error(err);
      }
      next();
    });
  }, function() {
    next();
  });
};

var finalFormat = function($, next) {
  // append pygments css
  $('head').append(pygmentsCss);

  // wrap all contents into a big div
  var allCont = $('body').children();
  $('body').html($('<div class="bookmain"></div>'));
  $('div.bookmain').append(allCont);

  // append bookheader and bookfooter
  $('body').prepend('<div class="bookheader"></div>');
  var cc = '<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.';
  $('body').append('<div class="bookfooter"><center>' + cc + '</center></div>');

  next();
};

function asyncSeriesWrap(func, $) {
  return function(next) {
    func($, next);
  };
}

require('fs').readFile(rawfilepath, function(err, data) {
  if (err) {
    return console.error(rawfilepath, err);
  }
  var html = data.toString();
  jsdom(html, function(errors, window) {
    var $ = jquery(window);
    async.series([
      asyncSeriesWrap(highlightCode, $),
      asyncSeriesWrap(finalFormat, $)
    ], function() {
      console.log(header + $('html').html() + footer);
    });
  });
});

