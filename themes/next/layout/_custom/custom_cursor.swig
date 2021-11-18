{% if theme.cursor_effect == "fireworks" %}
  <script async src="/js/cursor/fireworks.js"></script>
{% elif theme.cursor_effect == "love" %}
  <script type="text/javascript" src="/js/cursor/love.js"></script>
{% elif theme.cursor_effect == "text" %}
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/js/cursor/click_show_text.js"></script>
{% elif theme.cursor_effect == "explosion" %}
<canvas class="fireworks" style="position: fixed;left: 0;top: 0;z-index: 1; pointer-events: none;" ></canvas> 
<script type="text/javascript" src="/js/anime/anime.min.js"></script> 
<script type="text/javascript" src="/js/cursor/explosion.js"></script>
{% endif %}

