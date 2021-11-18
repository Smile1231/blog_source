{% if theme.cursor_effect == "fireworks" %}
  <script async src="/js/cursor/fireworks.js"></script>
{% elif theme.cursor_effect == "love" %}
  <script type="text/javascript" src="/js/cursor/love.js"></script>
{% elif theme.cursor_effect == "text" %}
<script type="text/javascript" src="http://libs.baidu.com/jquery/1.8.3/jquery.js"></script>
<script type="text/javascript" src="http://libs.baidu.com/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript" src="/js/cursor/click_show_text.js"></script>
{% elif theme.cursor_effect == "explosion" %}
<canvas class="fireworks" style="position: fixed;left: 0;top: 0;z-index: 1; pointer-events: none;" ></canvas> 
<script type="text/javascript" src="//cdn.bootcss.com/animejs/2.2.0/anime.min.js"></script> 
<script type="text/javascript" src="/js/cursor/explosion.js"></script>
{% endif %}

