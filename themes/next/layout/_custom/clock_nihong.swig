<div>
    <svg style="height: 60px;">
        <text id="time" text-anchor="middle" x="36%" y="80%" class="words words-1"></text>
        <text id="time" text-anchor="middle" x="36%" y="80%" class="words words-2"></text>
        <text id="time" text-anchor="middle" x="36%" y="80%" class="words words-3"></text>
        <text id="time" text-anchor="middle" x="36%" y="80%" class="words words-4"></text>
    </svg>
</div>

<script>
function showtime(){
    var noatime = new Date();
    var h = noatime.getHours(),
        m = noatime.getMinutes(),
        s = noatime.getSeconds();
    h=checktime(h);
    m=checktime(m);
    s=checktime(s);
  return h+":"+m+":"+s;
}

function checktime(x){
  if(x<10){
    x="0"+x;
  }
  return x;
}

var div1=document.getElementsByTagName("text");
setInterval(function(){
  for (var i in div1){
      div1[i].innerHTML=showtime();
  }
},1000);
</script>

<style>
.words{
    font-size: 50px;
    font-weight: bold;
    text-transform: uppercase;
    fill: none;
    stroke-width: 3px;
    stroke-dasharray: 35,125;
    animation-name: drawing;
    animation-duration: 6s;
    animation-iteration-count: infinite;
    animation-timing-function: linear;
}
.words-1{
    stroke: deepskyblue;
    text-shadow: 0 0 15px deepskyblue;
    animation-delay: -1.5s;
}
.words-2{
    stroke: lightseagreen;
    text-shadow: 0 0 15px lightseagreen;
    animation-delay: -3s;
}
.words-3{
    stroke: orange;
    text-shadow: 0 0 15px orange;
    animation-delay: -4.5s;
}
.words-4{
    stroke: purple;
    text-shadow: 0 0 15px purple;
    animation-delay: -6s;
}
@keyframes drawing {
    100%{
        stroke-dashoffset: -160
    }
}
</style>
