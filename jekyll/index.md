---
layout: home
---

<div class="index-content blog">
    <div class="section">
        <div class="cate-bar">
          <a href="{{ site.myblog.github }}"><i class="icon-github icon-large"></i><span> Get the source code!</span></a>
        </div>
        <ul class="artical-list">
        {% for post in site.categories.blog %}
            <li><div class="title-date">{{ post.date | date:"%Y-%m-%d" }}</div>
                <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
                <div class="title-desc">{{ post.description }}</div>
            </li>
        {% endfor %}
        </ul>
    </div>
    <script>
      $(function() {
        function geturl() {
          var all = [ {{ site.myblog.coverimgs }} ];
          return all[Math.floor((Math.random()*all.length))];
        }
        $('div.aside').css('background-image', geturl());
        $('div#avatar').transition({ scale: 2.5 }).transition({ opacity: 1, scale: 1 }, 800, 'ease');
      });
    </script>
    <div class="aside">
      <div id="avatar" class="avatar circle" style="width: 150px; height: 150px; position: absolute; right: -75px; top: 75px; opacity: 0;">
        <div class="center circle" style="margin-top: 4px; height: 142px; width: 142px; background-image: url('https://secure.gravatar.com/avatar/{{ site.myblog.gavatar }}?s=142')"></div>
      </div>
    </div>
    <div class="mobile-indicator"></div>
    <script>
      $(function() {
        var isMobileView = $('div.mobile-indicator').css('display') === 'none';
        if (isMobileView) {
          $(window).scroll(function(event) {
            console.log($('div.section').scrollTop());
            if ($(window).scrollTop() > 10) {
              $('div.avatar').transition({ opacity: 0 });
            } else {
              $('div.avatar').transition({ opacity: 1 });
            }
          });
        }
      });
    </script>
</div>
