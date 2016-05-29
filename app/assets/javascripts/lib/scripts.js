
(function($) {
    "use strict";
    /*==============================
        Is mobile
    ==============================*/
    var isMobile = {
        Android: function() {
            return navigator.userAgent.match(/Android/i);
        },
        BlackBerry: function() {
            return navigator.userAgent.match(/BlackBerry/i);
        },
        iOS: function() {
            return navigator.userAgent.match(/iPhone|iPad|iPod/i);
        },
        Opera: function() {
            return navigator.userAgent.match(/Opera Mini/i);
        },
        Windows: function() {
            return navigator.userAgent.match(/IEMobile/i);
        },
        any: function() {
            return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
        }
    }
    var windowWidth = window.innerWidth,
        windowHeight = $(window).height();



    /*==============================
        BLOG GRID
    ==============================*/
    function grid() {
        if ($('.blog-grid').length) {
            setTimeout(function() {
                $('.blog-grid .post-wrapper').masonry({
                    columnWidth: '.grid-item',
                    itemSelector: '.grid-item'
                });
            }, 1);
        }
    }

    function piPlaceholder() {
        var $ph = $('input[type="search"], input[type="text"], input[type="email"], textarea');
        $ph.each(function() {
            var value = $(this).val();
            $(this).focus(function() {
                if ($(this).val() === value) {
                    $(this).val('');
                }
            });
            $(this).blur(function() {
                if ($(this).val() === '') {
                    $(this).val(value);
                }
            });
        });
    }

    function navSliderImg() {
        $('.navslider-img').remove();
        if ($('.featured-slider').find('.owl-item.active').next().length === 0) {
            $('.featured-slider')
                .find('.owl-next .fa')
                    .before(function () {
                        var imgfirst = $('.featured-slider').find('.owl-item').first().find('img').attr('src');
                        return '<div class="navslider-img" style="background-image: url(' + imgfirst + ')">';
                    });
        } else {
            $('.featured-slider')
                .find('.owl-next .fa')
                    .before(function () {
                        var imgnext = $('.featured-slider').find('.owl-item.active').next().find('img').attr('src');
                        return '<div class="navslider-img" style="background-image: url(' + imgnext + ')">';
                    });
        }
        if ($('.featured-slider').find('.owl-item.active').prev().length === 0) {
            $('.featured-slider')
                .find('.owl-prev .fa')
                    .before(function () {
                        var imglast = $('.featured-slider').find('.owl-item').last().find('img').attr('src');
                        return '<div class="navslider-img" style="background-image: url(' + imglast + ')">';
                    });
        } else {
            $('.featured-slider')
                .find('.owl-prev .fa')
                    .before(function () {
                        var imgprev = $('.featured-slider').find('.owl-item.active').prev().find('img').attr('src');
                        return '<div class="navslider-img" style="background-image: url(' + imgprev + ')">';
                    });
        }
    }

    $.fn.imageCover = function() {
        $(this).each(function() {
            var self = $(this),
                image = self.find('img'),
                heightWrap = self.outerHeight(),
                widthImage = image.outerWidth(),
                heightImage = image.outerHeight();
            if (heightImage < heightWrap) {
                image.css({
                    'height': '100%',
                    'width': 'auto'
                });
            }
        });
    }
    
    function piFooterWidgets()
    {
        var $container = $(".pi_footer_widgets"), _class=$container.data("class");
            $container.find(".widget").wrap("<div class='"+_class+"'></div>");
    }

    function piIframeResponsive()
    {
        $("iframe").addClass("embed-responsive-item");
    }

    function piGridrotator()
    {
        var $riGrid = $("#ri-grid");
        if ($riGrid.length > 0) {
            $riGrid.gridrotator( {
                rows: 3,
                columns: 8,
                w1400: {
                    rows    : 2,
                    columns : 6
                },
                w1024: {
                    rows    : 2,
                    columns : 5
                },
                w768: {
                    rows    : 3,
                    columns : 3
                },
                w480 : {
                    rows : 8,
                    columns : 1
                },
                step: 'random',
                maxStep: 3,
                animType: 'random',
                animSpeed: 500,
                interval: 10000000,
                nochange : [],
                preventClick : false,
                resize: function () {
                    $('.pi-thumbs > li').each( function() { 
                        $(this).hoverdir({
                            speed: 250
                        });
                    });
                    var riWidth = $('.ri-grid ul li:last a').width(),
                        riHeight = $('.ri-grid ul li:last a').height();
                    $('.view-all')
                        .css({
                            'width': riWidth,
                            'height': riHeight
                        });
                },
                replaceItem: function (el) {
                    $('.caption', el).css({
                        left : '-100%'
                    });
                }
            });
        }
    }

    
    function PiNavigation() {
        /* Menu style */
        $('.pi-navigation').each(function() {
            var menu = $(this),
                openMenu = menu.find('.open-menu'),
                closeMenu = menu.find('.close-menu'),
                menuList = menu.find('.navlist'),
                subMenu = menu.find('.sub-menu'),
                header = $('#header'),
                windowWidth = window.innerWidth,
                windowHeight = $(window).height(),
                menuType = menu.data('menu-responsive');
            if (windowWidth < menuType) {
                openMenu.show();
                header.addClass('header-responsive');
                menuList
                    .addClass('off-canvas')
                    .css('height', windowHeight - 52);
                menuList
                    .children('.menu-item-has-children').removeClass('item-plus');
                if (menu.find('.submenu-toggle').length === 0) {
                    $('.menu-item-has-children, .navList > .menu-item-language-current')
                        .children('a')
                        .after(
                                '<span class="submenu-toggle">\
                                    <i class="fa fa-angle-right"></i>\
                                </span>\
                            ');
                    menuList.on('click', '.submenu-toggle', function(evt) {
                        evt.preventDefault();
                        $(this)
                            .siblings('.sub-menu')
                            .addClass('sub-menu-active');
                    });
                }
                subMenu.each(function() {
                    var $this = $(this);
                    if ($this.find('.back-mb').length === 0) {
                        $this
                            .prepend(
                                    '<li class="back-mb">\
                                        <a href="#">\
                                            Back\
                                        </a>\
                                    </li>\
                                ');
                    }
                    menu.on('click', '.back-mb a', function(evt) {
                        evt.preventDefault();
                        $(this)
                            .parent()
                            .parent()
                            .removeClass('sub-menu-active');
                    });
                });
                openMenu.on('click', function() {
                    menuList.addClass('off-canvas-active');
                    $(this).addClass('toggle-active');
                    closeMenu.show();
                });
                closeMenu.on('click', function() {
                    menuList.removeClass('off-canvas-active');
                    openMenu.removeClass('toggle-active');
                    $('.sub-menu').removeClass('sub-menu-active');
                    $(this).hide();
                });
                $('html').on('click', function() {
                    menuList.removeClass('off-canvas-active');
                    openMenu.removeClass('toggle-active');
                    $('.sub-menu').removeClass('sub-menu-active');
                    closeMenu.hide();
                });
                menu.on('click', function(evt) {
                    evt.stopPropagation();
                });

            } else {
                openMenu.hide();
                header.removeClass('header-responsive');
                menuList
                    .removeClass('off-canvas')
                    .css('height', 'auto');
                menuList
                    .children('.menu-item-has-children').addClass('item-plus');
                $('.back-mb, .submenu-toggle').remove();
            }
        });
    }

    function piEmptySocialAndSharing()
    {
        var $tagSharing = $(".tag-share");
        if ( $tagSharing.length > 0 )
        {
            if ( $tagSharing.children().length == 0 )
            {
                $tagSharing.remove();
            }
        }
    }

    function pageSlider() {
        var paginationSlider = ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>'];
        if ($(".featured-slider").length > 0) {
            $(".featured-slider").owlCarousel({
                autoPlay: 20000,
                slideSpeed: 300,
                navigation: true,
                pagination: false,
                singleItem: true,
                addClassActive : true,
                transitionStyle: 'fade',
                navigationText: ['<i class="fa fa-angle-left"></i>', '<i class="fa fa-angle-right"></i>'],
                afterMove: function() {
                    navSliderImg();
                }
            });
            navSliderImg();
            $('.featured-slider .item img')
                .before(function () {
                    var srcImg = $(this).attr('src');
                    return '<div class="item-img" style="background-image: url(' + srcImg + ')">';
                });
        }

        if ($(".twitter-slider").length > 0) {
            $(".twitter-slider").owlCarousel({
                autoPlay: false,
                slideSpeed: 300,
                navigation: true,
                pagination: false,
                singleItem: true,
                autoHeight: true,
                transitionStyle: 'fade',
                navigationText: paginationSlider
            });
        }
        
        if ($(".theme-slider").length > 0) {
            $(".theme-slider").owlCarousel({
                autoPlay: false,
                slideSpeed: 300,
                navigation: true,
                pagination: false,
                singleItem: true,
                autoHeight: true,
                navigationText: paginationSlider
            });
        }
    }

    function pageJs() {
        $('.blog-1st .post + .post .post-entry, .blog-grid .post .post-entry').each(function() {
            var numLine = 3,
                fontSize = 13, /* px */
                lineHeight = 1.8, /* em */
                height = fontSize * lineHeight * numLine;
            $(this).css({
                'font-size': fontSize + 'px',
                'line-height': lineHeight + 'em',
                'max-height': height,
                'overflow': 'hidden'
            });
        });

        $('.post.sticky .post-media').prepend('<div class="sticky-icon"><i class="fa fa-thumb-tack"></i></div>');

        $('.sidebar-left')
            .closest('.blog-content')
            .find('.col-md-9')
                .addClass('col-md-push-3');
        $('.sidebar-left')
            .closest('.blog-content')
            .find('.col-md-3')
                .addClass('col-md-pull-9');


        if (isMobile.any()) {
            $('html').addClass('ismobile');
        }

        $('.post-share').each(function() {
            $(this).find('.share-toggle').click(function() {
                $(this).toggleClass('toggle-active');
                $(this).siblings('.share').toggleClass('share-active');
            });
        });

        $('.search-box .fa-search').click(function() {
            $(this).toggleClass('active');
            $('.search-box input[type="search"]').toggleClass('fadein');
        });
        $('html').click(function() {
            $('.search-box .fa-search').removeClass('active');
            $('.search-box input[type="search"]').removeClass('fadein');
        });
        $('.search-box').click(function(evt) {
            evt.stopPropagation();
        });
        if ($('.sidebar').length > 0) {
            $('.sidebar').parent().theiaStickySidebar({
                updateSidebarHeight: true
            });
        }
    }

    function piMasonry() {
        if ($('.pi-masonry').length > 0) {
            setTimeout(function() {
                $('.pi-masonry').masonry({
                    columnWidth: '.post:nth-child(2)',
                    itemSelector: '.post'
                });
            }, 1);
        }
    }
    
    // Comment form
    function piEditSubmitButton()
    {
        var $formSubmit = $(".form-submit #submit");
        $(".form-submit").addClass("col-md-4");
        $formSubmit.wrap('<div class="form-actions"></div>');
        $formSubmit.addClass("pi-btn");
    }

    function piEmptyComment()
    {
        if ( $("#comments").length > 0 )
        {
            if ( $("#comments .comments-inner-wrap").children().length == 0 )
            {
                $("#comments").remove();
            }
        }
    }

    function piEmptyPagination()
    {
        if ( $(".pi-pagination-page").children().length == 0 )
        {
            $(".pi-pagination-page").remove();
        }
    }
    
    function comingsoon() {
        var wh = $(window).height(),
            sectionsocialHeight = $('.section-social').outerHeight(),
            comingsoonHeight = wh - sectionsocialHeight;
        $('.page-comingsoon')
            .find('.tb').css('min-height', comingsoonHeight);
    }
    function headerSticky() {
        var scrolltop = $(window).scrollTop();
        if (scrolltop > 150) {
            $('.header-inner').addClass('header-fixed');
        } else {
            $('.header-inner').removeClass('header-fixed');
        }
    }

    // READY FUNCTION
    $(document).ready(function() {
        pageJs();
        piFooterWidgets();
        piIframeResponsive();
        piEmptySocialAndSharing();
        piEditSubmitButton();
        piEmptyComment();
        piEmptyPagination();
        if ($('.blog-1st, .blog-grid').find('.sidebar').length === 0) {
           $('.blog-1st, .blog-grid').addClass('no-sidebar');
        }
        if (isMobile.iOS()) {
            $('.blog-heading')
                .addClass('fix-background-ios');
        }
    });
    // LOAD RESIZE FUNCTION
    $(window).on('load resize', function() {
        PiNavigation();
        comingsoon();
    });
    // LOAD FUNCTION
    $(window).load(function() {
        // $('#preloader').fadeOut(1000);
        piGridrotator();
        // pageSlider();
        // grid();
        // piPlaceholder();
        // $('.author-thumb').imageCover();
        // $('.image-cover').imageCover();
        // $('.widget_slider .image-wrap').imageCover();
        // $('.blog-list .post .image-wrap').imageCover();
        piMasonry();
    });
    $(window).scroll(function() {
        headerSticky();
    });
})(jQuery);