//import QtQuick 2.3
//import QtQuick.Controls 1.2

Item {
  width: 110
  height: 30

  id: item
  
  property var src: ""
  property var htmlTag

  Component.onCompleted: create()
  
  function create() {
      item.dom.style.pointerEvents = "auto";      
      item.dom.innerHTML = '<audio controls><source></audio>';
      var r = item.dom.firstChild.firstChild;      
      r.src = item.src;
      htmlTag = item.dom.firstChild;
  } 

  onSrcChanged: create()
 
}
