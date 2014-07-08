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

var header = '<?xml version="1.0" encoding="UTF-8" standalone="no"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml">';
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

require('fs').readFile(rawfilepath, function(err, data) {
  if (err) {
    return console.error(rawfilepath, err);
  }
  var html = data.toString();
  jsdom(html, function(errors, window) {
    var $ = jquery(window);
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
      $('head').append(pygmentsCss);
      console.log(header + $('html').html() + footer);
    });
  });
});
