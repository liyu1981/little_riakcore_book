---
layout: home
---

<div class="index-content blog">
    <div class="section">
        <div class="cate-bar">
          <a href="{{ site.myblog.github }}"><i class="icon-github icon-large"></i><span> Get the source code!</span></a>
        </div>
        <ul class="artical-list">
Lato is a sanserif typeface family designed in the Summer 2010 by Warsaw-based designer Łukasz Dziedzic (“Lato” means “Summer” in Polish). In December 2010 the Lato family was published under the open-source Open Font License by his foundry tyPoland, with support from Google.

In the last ten or so years, during which Łukasz has been designing type, most of his projects were rooted in a particular design task that he needed to solve. With Lato, it was no different. Originally, the family was conceived as a set of corporate fonts for a large client — who in the end decided to go in different stylistic direction, so the family became available for a public release.

When working on Lato, Łukasz tried to carefully balance some potentially conflicting priorities. He wanted to create a typeface that would seem quite “transparent” when used in body text but would display some original traits when used in larger sizes. He used classical proportions (particularly visible in the uppercase) to give the letterforms familiar harmony and elegance. At the same time, he created a sleek sanserif look, which makes evident the fact that Lato was designed in 2010 — even though it does not follow any current trend.

The semi-rounded details of the letters give Lato a feeling of warmth, while the strong structure provides stability and seriousness. “Male and female, serious but friendly. With the feeling of the Summer,” says Łukasz.

Lato consists of five weights (plus corresponding italics), including a beautiful hairline style.
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
