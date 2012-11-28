# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(".approve-button, .reject-button").click ->
  btn = $(this)
  btn.button "loading"

$("#download-images-link").live "click", ->
  btn = $(this)
  btn.button "loading"
