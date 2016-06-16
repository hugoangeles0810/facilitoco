$(document).on "click", ".file-activate", (ev)->
  selector = $(this).attr("for")
  $(selector).click()

$(document).on "change", ".remotipart", ()->
  $(this).parent().submit()