
$(document).ready(function () {
    // Hide the initial description box
    $(".feature-box .title").hide();
    
    $(".feature-box").hover(function(){
        console.log("hover in");
        $(this).children(".title").fadeOut(150);
        $(this).children(".description").fadeIn(150);

    }, function(){
        console.log("hover out");
        $(this).children(".title").fadeIn(150);
        $(this).children(".description").fadeOut(150);
    });

});