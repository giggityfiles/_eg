const WebSocket = require('ws');

const nodelist = ["wss://collabvmserver.net/vm0"]; // multiple vm websockets here

function uwu() {
  nodelist.forEach((uwu) => {
    var wawa = new WebSocket(uwu, "guacamole");
    wawa.onopen = () => {
      wawa.send("4.list;");
    }
    wawa.onmessage = (event) => {
      var mrrp = fix(event.data.toString());
      if (mrrp[0] == 'list') {
        wawa.close();
        guh(uwu, mrrp[1]);
      }
    }
    wawa.onerror = (err) => {
      console.warn(uwu.slice(uwu.lastIndexOf('/') + 1) + " seems to have fallen off the path qwq\n" + err.message);
    }
  });
}

function guh(url, node) {
  var wawa = new WebSocket(url, "guacamole");
  wawa.onopen = () => {
    wawa.send(`6.rename,9.goob${Math.floor(Math.random() * 100000)};`); // goob > guest
    wawa.send("3.nop;");
    wawa.send(`4.chat,13.bing chilling;`); // 4.chat,{msg.length}.{msg};
    //guh(url, node); // this will flood
  }
  wawa.onmessage = (event) => {
    var mrrp = fix(event.data.toString());
    if (!mrrp) return;
    switch (mrrp[0]) {
      case 'nop':
        wawa.send("3.nop;");
        break;
      default:
        break;
    }
  }
  wawa.onclose = () => {
    console.warn("disconnected qwq");
    guh(url, node);
  }
  wawa.onerror = () => {
    console.warn("websocket connection broke qwq");
  }
}

// very very cursed
function fix(uwu) {
  var owo = [];
  while (uwu) {
    if (isNaN(uwu[0])) return null;
    let qwq = uwu.replace(/(^\d+)(.+$)/i, '$1');
    owo.push(uwu.substring(qwq.length + 1, qwq.length + 1 + parseInt(qwq)));
    uwu = uwu.substring(qwq.length + parseInt(qwq) + 2);
  }
  return owo;
}

uwu();