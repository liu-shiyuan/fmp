(function ($) {
    //define the commands that can be used
    var commands = {
       load: load
    };
    var tabTitle,tabs,dialog
    $.fn.fmp_tab = function (options) {
        if (typeof arguments[0] === 'string') {
            //execute string comand on fmpTabs
            var property = arguments[1];
            //remove the command name from the arguments
            var args = Array.prototype.slice.call(arguments);
            args.splice(0, 1);
            commands[arguments[0]].apply(this, args);
        }
        else {
          //create fmpTabs
          createFmpTabs.apply(this, arguments);
        }
        return this;
    };

    function createFmpTabs(options){
        var opts={ 
            tab_item_name:'item',
            callback:function(){}
        };
        $.extend(opts,options);
        //fmpTabs initialisation code
        myid=$(this).eq(0).attr('id');
        add_name='Add '+opts.tab_item_name
        add_tab_name=opts.tab_item_name+' data'
        this.before('<div id="dialog" title="'+add_tab_name+'"><form><fieldset class="ui-helper-reset"><label for="tab_title">'+opts.tab_item_name+' name</label><input type="text" name="tab_title" id="tab_title" value="" placeholder="Enter '+opts.tab_item_name+' name" class="ui-widget-content ui-corner-all"><textarea name="tab_content" id="tab_content" class="ui-widget-content ui-corner-all" style="display:none"></textarea></fieldset></form></div><button id="add_tab">'+add_name+'</button>')
        this.append('<ul><li><a href="#'+myid+'-1">'+opts.tab_item_name+'1</a> <span class="ui-icon ui-icon-close" role="presentation">Remove '+opts.tab_item_name+'</span></li></ul><div id="'+myid+'-1"><p>content</p></div>');
        //////////////////////////////////////
        tabTitle = $( "#tab_title" ),
        tabContent = $( "#tab_content" ),
        tabTemplate = "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' role='presentation'>Remove "+opts.tab_item_name+"</span></li>",
        tabCounter = 1;

        tabs = $( "#"+myid ).tabs();

        // modal dialog init: custom buttons and a "close" callback resetting the form inside
        dialog = $( "#dialog" ).dialog({
            autoOpen: false,
            modal: true,
            buttons: {
                Add: function() {
                    addTab();
                    $( this ).dialog( "close" );
                },
                Cancel: function() {
                    $( this ).dialog( "close" );
                }
            },
            close: function() {
                form[ 0 ].reset();
            }
        });

        // addTab form: calls addTab function on submit and closes the dialog
        var form = dialog.find( "form" ).submit(function( event ) {
            addTab();
            dialog.dialog( "close" );
            event.preventDefault();
        });
        // addTab button: just opens the dialog
        $( "#add_tab" )
        .button()
        .click(function() {
            dialog.dialog( "open" );
        });

        // close icon: removing the tab on click
        tabs.delegate( "span.ui-icon-close", "click", function() {
            var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
            $( "#" + panelId ).remove();
            tabs.tabs( "refresh" );
        });

        tabs.bind( "keyup", function( event ) {
            if ( event.altKey && event.keyCode === $.ui.keyCode.BACKSPACE ) {
                var panelId = tabs.find( ".ui-tabs-active" ).remove().attr( "aria-controls" );
                $( "#" + panelId ).remove();
                tabs.tabs( "refresh" );
            }
        });

        // css
        $(".ui-dialog .ui-dialog-title").css({"color":"gray","font-weight":"lighter"})
        $("#dialog label, #dialog input").css({"display":"block","font-size":"12px"})
        $("#dialog label").css({"margin-top":"0.5em","font-size":"12px"})
        $("#dialog input, #dialog textarea").css({"width":"95%","font-size":"12px"})
        $("#tabs").css({"margin-top":"1em","font-size":"12px"})
        $("#tabs li .ui-icon-close").css({float:"left",margin:"0.4em 0.2em 0 0",cursor:"pointer","font-size":"12px"})
        $("#add_tab").css("cursor","pointer")
        $(".ui-widget-header").css({border:"none",background:"none"})

        //do callback after all
        opts.callback()
    }

    // actual addTab function: adds new tab using the input from the form above
    function addTab() {
        var label = tabTitle.val() || "Product " + tabCounter,
        id = myid+"-" + tabCounter,
        li = $( tabTemplate.replace( /#\{href\}/g, "#" + id ).replace( /#\{label\}/g, label ) ),
        tabContentHtml = tabContent.val() || "<div class=\"form-group\"><label for=\"product_link\">Product Link<code></code></label><input type=\"text\" class=\"form-control\" id=\"productLink\" name=\"productLink\" placeholder=\"Enter Link\" value=\"\"></div><div class=\"form-group\"><label for=\"product_description\">Product Description<code></code></label><input type=\"text\" class=\"form-control\" id=\"productDesscription\" name=\"productDesscription\" placeholder=\"Enter Description\" value=\"\"><label for=\"Picture\">Picture<code></code></label></div>";
        tabs.find( ".ui-tabs-nav" ).append( li );
        tabs.append( "<div id='" + id + "'><p>" + tabContentHtml + "</p></div>" );
        tabs.tabs( "refresh" );
        tabCounter++;
    }

    function addTabFromData(tb_tit,tb_content) {
        var label = tb_tit
        id = myid+"-" + tabCounter,
        li = $( tabTemplate.replace( /#\{href\}/g, "#" + id ).replace( /#\{label\}/g, label ) ),
        tabContentHtml = tb_content;
        tabs.find( ".ui-tabs-nav" ).append( li )
        tabs.append( "<div id='" + id + "'><p>" + tabContentHtml + "</p></div>" )
        tabs.tabs( "refresh" )
        tabCounter++
    }

    //Exposed functions 
    function load(tabs) {
        //code to load dhtml tabs elements 
        $(tabs).each(function(k,v){
            addTabFromData(v.title,v.content)
        })
    }
})(jQuery);
