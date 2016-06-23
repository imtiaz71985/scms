<style>
.carousel-inner > .item > img,
.carousel-inner > .item > a > img {
    width: 65%;
    margin: auto;
}
</style>

<div id="myCarousel" class="carousel slide" data-ride="carousel">
    <!-- Indicators -->
    <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li>
        <li data-target="#myCarousel" data-slide-to="3"></li>
        <li data-target="#myCarousel" data-slide-to="4"></li>
        <li data-target="#myCarousel" data-slide-to="5"></li>
    </ol>

    <!-- Wrapper for slides -->
    <div class="carousel-inner" role="listbox">
        <div class="item active">
            <img src="images/dash_01.jpg" alt="Hatia">
        </div>

        <div class="item">
            <img src="images/dash_02.jpg" alt="Hatia">
        </div>

        <div class="item">
            <img src="images/dash_03.jpg" alt="Hatia">
        </div>

        <div class="item">
            <img src="images/dash_04.jpg" alt="Hatia">
        </div>

        <div class="item">
            <img src="images/dash_05.jpg" alt="Hatia">
        </div>
        <div class="item">
            <img src="images/dash_06.jpg" alt="Hatia">
        </div>
    </div>

    <!-- Left and right controls -->
    <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>
