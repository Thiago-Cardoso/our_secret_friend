$(document).on 'turbolinks:load', -> #after page loading
  $('.modal').modal();
# event blur when focusout call submit
  $('.update_campaign input').bind 'blur', ->
    #force submit
    $('.update_campaign').submit()
    #send submit ajax for update
  $('.update_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'PUT'
        dataType: 'json',
        data: $(".update_campaign").serialize() #get all fields
        success: (data, text, jqXHR) ->
          Materialize.toast('Campanha atualizada', 4000, 'green') #sucess
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na atualização da Campanha', 4000, 'red') #error
    return false

  $('.member_update').on 'change', 'div.member_id', (e) ->
    $.ajax '/members/' + e.currentTarget.id,
        type: 'PUT'
        dataType: 'json',
        data: { member: {
                name: $("#name_" + e.currentTarget.id).val(),
                email: $("#email_" + e.currentTarget.id).val(),
                campaign_id: $('#campaign_id').val()
              } }
        success: (data, text, jqXHR) ->
          Materialize.toast('Membro atualizado', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na atualização da Membro', 4000, 'red')
    return false

    #send submit ajax for delete
  $('.remove_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'DELETE'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          $(location).attr('href','/campaigns'); #redirect for home
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na remoção da Campanha', 4000, 'red')
    return false

   #close modal
   #$('#close').click ->
      #$('#modal1').modal('close');

    #send sumit for raffle_campaign
  $('.raffle_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          Materialize.toast('Tudo certo, em breve os participantes receberão um email!', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast(jqXHR.responseText, 4000, 'red')
    return false
