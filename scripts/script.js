
$(document).ready(function () {
    // Hide the initial description box
    $(".feature-box .description").hide();
    $(".feature-box .description-background").hide();
    
    $(".feature-box").hover(function(){
        $(this).children(".title").fadeOut(1);
        $(this).children(".description").fadeIn(1);
        $(this).children(".description-background").fadeIn(1);

    }, function(){
        
        $(this).children(".title").fadeIn(1);
        $(this).children(".description").fadeOut(1);
        $(this).children(".description-background").fadeOut(1);
    });
    
    //Add the array of project names to automatically populate
//    var projectsArray = 
    $("#more").click(function(){
       $(this).hide();
       $("#extra").show();
    });
    
    $(".feature-box").click(function(){
        var page = $(this).attr("id");
        console.log(page);
       window.location.href = "projects/articles/"+ page + ".html"; 
    });
    
    $(".sideIcon").click(function(){
        var page = $(this).attr("id");
        console.log(page);
       window.location.href = "../../projects/articles/"+ page + ".html"; 
    });
    

});