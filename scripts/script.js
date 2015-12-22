
$(document).ready(function () {
    // Hide the initial description box
    $(".feature-box .description").hide();
    $(".feature-box .description-background").hide();
    
    $(".feature-box").hover(function(){
        console.log("hover in");
        $(this).children(".title").fadeOut(50);
        $(this).children(".description").fadeIn(50);
        $(this).children(".description-background").fadeIn(50);

    }, function(){
        console.log("hover out");
        $(this).children(".title").fadeIn(50);
        $(this).children(".description").fadeOut(50);
        $(this).children(".description-background").fadeOut(50);
    });

});