/// <reference path="jquery-1.7.1.intellisense.js" />
$(document).ready(function () {


    $("#menu1").wijmenu({
        orientation: "horizontal"
    });
    $("#tagcloud a").tagcloud({
        size: {
            start: 12,
            end: 28,
            unit: 'px'
        },
        color: {
            start: "#CDE",
            end: "#FS2"
        }
    });
    $infoAlert = $("<div></div>").dialog({
        autoOpen: false,
        title: "Greška",
        modal: true,
        resizable: false,
        height: 180,
        dialogClass: "infoDialog",
        buttons: {
            "Ok": function () {
                $(this).dialog("close");
            }
        }
    });

    $(".dialog_error").dialog({
        title: "Greška",
        resizable: false,
        height: 180,
        modal: true,
        buttons: {
            "Ok": function () {
                $(this).dialog("close");
            }
        }
    });


    $('#wizard').smartWizard();
    $('#star').raty({
        score: $("#rat-wiki").val(),
        click: function (score, evt) {
            var id = $("#star").attr("data-wiki-id");

            $.post("/Articles/Rating", { id: id, score: score }, function (data) {
                if (data === "False") {
                    $infoAlert.html("Već ste ocjenili ovaj članak").dialog('open');
                    $('#star').raty({ readOnly: true, score: $("#rat-wiki").val(), noRatedMsg: 'Već ste glasali!' });
                    return;
                }
                else {
                    window.location.reload(true);
                }
            });
        }
    });
    $("body").niceScroll({ touchbehavior: false, cursorcolor: "Grey", cursoropacitymax: 0.7, cursorwidth: 10, background: "#ccc", autohidemode: true });
    $("#pitanja-box").niceScroll({ touchbehavior: false, cursorcolor: "Grey", cursoropacitymax: 0.7, cursorwidth: 6, background: "#ccc", autohidemode: true });

    $('body').bind('DOMNodeRemoved', function (event) {
        $("#pitanja-box").getNiceScroll().resize();
    });

    $('body').bind('DOMNodeInserted', function (event) {
        $("#pitanja-box").getNiceScroll().resize();
    });

    $(".comment a").live("click", function () {


        $a = $(this);
        var id = $a.attr("data-targetID");

        $("#" + id).toggleClass("disNone");
        $("#" + id + " .comment_textarea").focus();
        return false;

    });

    $(".comment_btn").live("click", function () {


        var komentar = $(this).prev(".comment_textarea").val();
        if (komentar.length == 0) { return false; }

        $(this).prev().val(htmlEncode(komentar));
        var form = $(this).parents('form:first');
        form.submit();

    });



    $(".accordian-comments").accordion({ collapsible: true, autoHeight: false });
    $(".accordian-comments").accordion("option", "active", false);

    var getPage = function () {
        $a = $(this);
        var link = $("#tabs .youarehere").attr("href");
        var mySplitResult = link.split("=");

        link = $a.attr("href") + "&tab=" + mySplitResult[1];

        var options = {
            url: link,
            type: "GET"
        };
        $.ajax(options).done(function (data) {

            var target = $a.parents("div#pagedList").attr("data-wiki-target");

            $(target).replaceWith(data);


        });
        return false;

    };
    $("#content-body").on("click", "#pagedList a", getPage);


    var getPageSearched = function () {
        $a = $(this);
        var link = $a.attr("href");


        var options = {
            url: link,
            type: "GET"
        };
        $.ajax(options).done(function (data) {

            var target = $a.parents("div#pagedListSearched").attr("data-questions-target");
            console.log(target);
            $(target).html(data);


        });
        return false;

    };
    $("#content-body").on("click", "#pagedListSearched a", getPageSearched);


    $("#tabs a").click(function () {
        $a = $(this);
        var options = {
            url: $a.attr("href"),
            type: "GET"
        };
        $.ajax(options).done(function (data) {
            $(".questions").replaceWith(data);


        });
        $("#tabs a").removeClass("youarehere");
        $a.addClass("youarehere");
        return false;

    });
    $("#tabs a").click(function () {
        $a = $(this);
        var options = {
            url: $a.attr("href"),
            type: "GET"
        };
        $.ajax(options).done(function (data) {
            $(".questions").replaceWith(data);


        });
        $("#tabs a").removeClass("youarehere");
        $a.addClass("youarehere");
        return false;

    });


    $("#answers-submenu #tabs a").on("click", function (e) {

        e.preventDefault();
        $a = $(this);
        var options = {
            url: $a.attr("href"),
            type: "GET"
        };
        $.ajax(options).done(function (data) {

            $("#answers-wrap").html(data);
            $(".accordian-comments").accordion({ collapsible: true, autoHeight: false });
            $(".accordian-comments").accordion("option", "active", false);
        });
        $("#answers-submenu #tabs a").removeClass("youarehere");
        $a.addClass("youarehere");



    });

    $("#like a").live("click", function () {
        $a = $(this);
        var options = {
            url: $a.attr("href"),
            type: "GET"
        };
        $.ajax(options).done(function (data) {

            if (data === "False") {

                $infoAlert.html("Već ste se izajsnili da volite ovo pitanje!").dialog('open');
                return;
            }
            var id = data.id;
            $("#" + id).text(data.likes);
        });
        return false;
    });

    $('.textarea').wysihtml5();
    $("#btn-wiki-like").click(function () {
        var id = $("#likes-wiki-num").attr("data-id");
        $.post("/Articles/Like", { id: id }, function (data) {

            if (data === "False") {
                $infoAlert.html("Već ste se izajsnili da volite ovaj članak!").dialog('open');
                return;
            }
            $("#likes-wiki-num").html(data);
        });
    });
    $("#kategorije-izbor li").click(function () {
        $(this).find(".c-chk input").attr("checked", !$(this).find(".c-chk input").attr("checked"));
        $(this).toggleClass("active");
    });
    $("#btnTransferKategrija").click(function () {
        var str = "";
        if ($("#kategorije-izbor li").find(":checked").length <= 0) {
            $infoAlert.html("Molimo odaberite barem jedanu kategoriju\nUkoliko ne želite, prekinte operaciju!").dialog('open');
            return;
        }
        $("#kategorije-izbor li").each(function () {
            if ($(this).find(".c-chk input").attr("checked")) {
                str += "  <li class='ktc' data-id=" + $(this).attr("data-id") + ">" +
                              " <div class='nzv pull-left'>" + $(this).attr("data-nk") + "</div>" +
                               "<div class='sk-close pull-right' onclick='BrisiContent(this)'>×</div>" +
                          "</li>";
            }
        });
        $("#kategorije-izbor li").each(function () {
            $(this).find(".c-chk input").attr("checked", false);
            $(this).removeClass("active");
        });
        $("#selektovaneKategorije").html(str);
        $("#KategorijeAdd").modal("hide");
    });
    $("#txtNazivWikiClanka").focus(function () {
        if ($("#txtNazivWikiClanka").val() == "Naziv članka...") {
            $("#txtNazivWikiClanka").val("");
            $("#txtNazivWikiClanka").toggleClass("active-wiki-focus");
        }
    });
    $("#txtNazivWikiClanka").blur(function () {
        if ($("#txtNazivWikiClanka").val() == "") {
            $("#txtNazivWikiClanka").val("Naziv članka...");
            $("#txtNazivWikiClanka").toggleClass("active-wiki-focus");
        }
    });
    $("#txtTags").keypress(function (e) {
        var kod = (e.keyCode ? e.keyCode : e.which);
        if (kod == 13) {
            if ($(this).val() == "") {
                $("#dialog").dialog({
                    resizable: false,
                    buttons: {
                        "Ok": function () {
                            $(this).dialog("close");
                        }
                    }
                }).parent().addClass("ui-state-info"); return false;
            }
            var str = " <li class='tgc' data-id='-1'> <div class='nzv pull-left'>" + $(this).val() + "</div><div class='sk-close pull-right' onclick='BrisiTag(this)'>×</div></li>";
            var err = false;
            $("#selektovaniTagovi li.tgc").each(function () {
                if ($(this).find(".nzv").html() == $("#txtTags").val()) {

                    $infoAlert.html("Tag je već na listi").dialog('open');
                    err = true;
                }
            });
            if (err != true) {
                $("#selektovaniTagovi").prepend(str);
            }
            $("#txtTags").val("");
        }
    });
    $("#txtTags").typeahead({
        source: function (typeahead, argument) {
            $.ajax({
                url: "/Articles/GetTags",
                dataType: "json",
                type: "POST",
                data: { arg: argument },
                success: function (data) {
                    var lista = [], i = data.length;
                    while (i--) {
                        lista[i] = { id: data[i].TagID, value: data[i].Name };
                    }
                    typeahead.process(lista);
                }
            });
        },
        onselect: function (obj) {

            var str = " <li class='tgc' data-id='" + obj.id + "'> <div class='nzv pull-left'>" + obj.value + "</div><div class='sk-close pull-right' onclick='BrisiTag(this)'>×</div></li>";
            var err = false;
            $("#selektovaniTagovi li.tgc").each(function () {
                if ($(this).find(".nzv").html() == obj.value) {

                    $infoAlert.html("Tag je već na listi").dialog('open');
                    err = true;
                }
            });
            if (err != true) {
                $("#selektovaniTagovi").prepend(str);
            }
            $("#txtTags").val("");
        }
    });



    $("#txtSearch-Args").keypress(function () {
        $("#AI-Search-Complete").show();
        $.post("/Wellcome/GetAI", { args: $("#txtSearch-Args").val() }, function (data) {
            data = $.parseJSON(data);
            GetHtmlForAi(data);
        });
    });
    $(".Preporuka-wikis li").mouseover(function () {
        $(this).tooltip({ placement: "left" }); $(this).tooltip("show");
    });

    $("*").click(function () {
        $("#AI-Search-Complete").hide();
    });
    $("#btnPostKomentar").click(function () {
        var commentar = $("#txtKomenatarBox").val();
        if (!commentar) {

            $infoAlert.html("Polje ne smije biti prazno!").dialog('open');

            $("#txtKomenatarBox").focus();
            return;
        }
        else {
            $("#frmKoment").submit();
        }
    });

    $(".kat-center").click(function () {
        $("#tagcloud a").removeClass("activ_tag");
        $(".kat-center").removeClass("activ_kat");
        $(this).addClass("activ_kat");

        var id = $(".activ_kat").attr("id");

       
        var link = "Wellcome/get_questions_by_kategory?id=" + id;

      
        var options = { url: link, type: "GET" };

        $.ajax(options).done(function (data) {


            $("#update-pitanja").html(data);
           
        });

        return false;
    });


    $("#tagcloud a").click(function () {

        $(".kat-center").removeClass("activ_kat");
        $("#tagcloud a").removeClass("activ_tag");
        $(this).addClass("activ_tag");

        var id = $(this).attr("id");


        var link = "Wellcome/get_questions_by_tag?id=" + id;
       

        var options = { url: link, type: "GET" };

        $.ajax(options).done(function (data) {


            $("#update-pitanja").html(data);

        });

        return false;
    });


});



function GetElement(d) {
    return " <li onclick='GetLink(&#39;&#47;Wiki-Show&#47;" + d.ArticlesID + "&#39;)'>"
               + "<div class='Naslov-ai'><strong>" + d.Name + "</strong></div>"
                + "<div class='Content-ai'>" + htmlDecode(d.Content).toString().substr(0, 150) + "</div>"
                + "<div class='Sett-ai'>Pogleda [" + d.Views + "] ·  Datum objave [" + d.DatePublish + "]</div>"
    "</li>";
}
function GetHtmlForAi(data) {
    var s = "";
    for (var i = 0; i < data.length; i++) {
        s += GetElement(data[i]);
    }
    $("#rezult-list").html(s);
    $("#rev-w-f-p").html("Revalantnih rezultat " + data.length);
}
function htmlEncode(value) {
    return $('<div/>').text(value).html();
}

function htmlDecode(value) {
    return $('<div/>').html(value).text();
}
//Registracija korisnika - event
function SubmitRegistartion(a) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    var hasErorr = false;
    var tmp = $(a).find("#fn");
    if (!tmp.val()) {
        $infoAlert.html("Polje za ime mora biti popunjeno!").dialog('open');
        hasErorr = true;
        return;
    }
    tmp = $(a).find("#ln");
    if (!tmp.val()) {
        $infoAlert.html("Polje za prezime mora biti popunjeno!").dialog('open');
        hasErorr = true;
        return;
    }
    tmp = $(a).find("#em");
    if (!tmp.val()) {
        $infoAlert.html("Polje za email mora biti popunjeno!").dialog('open');
        hasErorr = true;
        return;
    }
    if (!emailReg.test(tmp.val())) {
        $infoAlert.html("Unesite validnu e-mail adresu!").dialog('open');
        hasErorr = true;
        return;
    }
    tmp = $(a).find("#emr");
    if (!tmp.val()) {
        $infoAlert.html("Molimo Vas da ponovite e-mail!").dialog('open');
        hasErorr = true;
        return;
    }
    tmp = $(a).find("#pass");
    if (!tmp.val()) {
        $infoAlert.html("Molimo Vas da kreirate password!").dialog('open');
        hasErorr = true;
        return;
    }

    tmp = $(a).find("#em");
    tmpr = $(a).find("#emr");
    if (tmp.val() != tmpr.val()) {
        $infoAlert.html("E-mail se moraju podudarati!").dialog('open');
        hasErorr = true;
        return;
    }

    if (hasErorr == false) {
        $(a).submit();
    }
}
function SubmitLogin(a) {

    if (!$(a).find("#user").val() || !$(a).find("#pass").val()) {

        $infoAlert.html("Polje za email i lozinku moraju biti popunjena.").dialog('open');
        return;
    }

    $(a).submit();
}
function Registartion() {
    $("#Registartion").modal("show").css({ 'margin-left': function () { return -($(this).width() / 2); } });
}
function Logins() {
    $("#Login").modal("show").css({ 'margin-left': function () { return -($(this).width() / 2); } });
}
function MenuShow(a) {
    $(a).toggle();
}
function ShowDialog(a) {
    $(a).modal("show").css({ 'margin-left': function () { return -($(this).width() / 2); } }).appendTo($("body"));
}

function BrisiContent(a) {
    $(a).parent().remove();

    if ($("#selektovaneKategorije li").length == 0) {
        $("#selektovaneKategorije").html("<li class='kat-box-desc'>Molimo Vas da odaberete kategorije za ovaj članak</li>");
    }
}
function BrisiTag(a) {
    $(a).parent().remove();
}
function SnimiWikiClanak() {
    if (!$("#wiki-content").val() || $("#txtNazivWikiClanka").val() == "Naziv članka...") {
        $infoAlert.html("Molimo Vas da uneste naziv za članak i njegv sadržaj!").dialog('open');
        return;
    }
    if ($("#selektovaneKategorije li.ktc").length == 0) {
        $infoAlert.html("Molimo Vas da selektujete određenu kategoriju!").dialog('open');
        ShowDialog("#KategorijeAdd");
        return;
    }
    var kategorije = new Array();
    var Tagovi = new Array();
    $("#selektovaneKategorije li.ktc").each(function () {
        kategorije.push({ KategorijaID: $(this).attr("data-id") });
    });
    $("#selektovaniTagovi li.tgc").each(function () {
        Tagovi.push({ TagID: $(this).attr("data-id"), Naziv: $(this).find(".nzv").html() });
    });

    kategorije = JSON.stringify(kategorije);
    Tagovi = JSON.stringify(Tagovi);

    $("#jsonTag").val(Tagovi);
    $("#jsonKat").val(kategorije);

    var con = $("#wiki-content").val();

    $("#wiki-content").val(htmlEncode(con));

    $("#frmAddNewWiki").submit();

}

function SaveQuestions() {
    if ($("#txtNaslovPitanja").val() == "" || $("#questions-content").val() == "") {
        $infoAlert.html("Molimo Vas da uneste naslov i njegov sadržaj!").dialog('open');
        return;
    }
    if ($("#questions-content").val().length < 10) {

        $infoAlert.html("Molimo Vas da unesete pitanje sa minimalno 10 znakova!").dialog('open');
        return;
    }
    if ($("#selektovaneKategorije li.ktc").length == 0) {
        $infoAlert.html("Molimo Vas da selektujete određenu kategoriju!").dialog('open');
        ShowDialog("#KategorijeAdd");
        return;
    }


    var kategorije = new Array();
    var Tagovi = new Array();
    $("#selektovaneKategorije li.ktc").each(function () {
        kategorije.push({ KategorijaID: $(this).attr("data-id") });
    });
    $("#selektovaniTagovi li.tgc").each(function () {
        Tagovi.push({ TagID: $(this).attr("data-id"), Naziv: $(this).find(".nzv").html() });
    });

    kategorije = JSON.stringify(kategorije);
    Tagovi = JSON.stringify(Tagovi);

    $("#jsonTagQuestion").val(Tagovi);
    $("#jsonKatQuestion").val(kategorije);


    var con = $("#questions-content").val();

    $("#questions-content").val(htmlEncode(con));

    $("#frmAddNewQuestion").submit();

}



function GetLink(a) {
    window.location = a;
}

function SaveAnswer() {
    if ($("#answer-content").val() == "") {
        $infoAlert.html("Molimo Vas da unesete odgovor!").dialog('open');
        return;
    }

    var con = $("#answer-content").val();
    $("#answer-content").val(htmlEncode(con));



    $("#frmAddAnswer").submit();

}

function LogOut(a) {

    window.location.pathname = "Home/LogOut";
    return false;
}

