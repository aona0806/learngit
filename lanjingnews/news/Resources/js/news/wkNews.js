
function getBase64Image(img) {
    var canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    
    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0, img.width, img.height);
    
    var dataURL = canvas.toDataURL("image/png");
    //    return dataURL
    return dataURL.replace("data:image/png;base64,", "");
}

function weksdkCall(name , param){
    var message = {
        'name' : name,
    };
    message['param'] = param;
    window.webkit.messageHandlers._weksdk_.postMessage(message);
}

var imgs = document.getElementsByTagName("img");
var imgsUrl = new Array(imgs.length);

for (i = 0 ; i < imgs.length ; i++){
    
    if ( imgs[i].onclick == null ) {
        
        imgs[i].onclick = function(){
            
            var src = this.src;
            
            weksdkCall('showimage',{'url':src});
        }
    }
    imgsUrl.push(imgs[i].src);
    
}

weksdkCall('allImages',{'urls':imgsUrl});

//allImages(imgsUrl);

