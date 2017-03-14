$(document).ready(->

  clearField = () ->
    $('#productselectionfield').html('')
    $('.pagination').html('')
  insertProduct = (product) ->
    $('#productselectionfield').append("<div class='product' id='product#" +
      product.id+"'><img src='"+product.product_images[0].image.thumb.url+"'><span>"+
      product.brand+"</span><span>"+
      product.short_description+"</span><span>"+
      product.price + "</span></div>")

  insertClear = ->
    $('#productselectionfield').append("<div class='clear'></div>")

  updateEventListener = ->
    $('.product').click( -> 
      id = $(this).attr('id');
      id = id.replace('product#', ''); 
      $(".myprod").html($(this).clone().html())
      $('#auction_product_id').val(id)
      $('#productSelectPopup').hide()
    )
    $(".pagination a").click( ->
      search = $('#search_hidden').val()
      page = $(this).attr('id');
      page = page.replace('pagination#', ''); 
      if search == ''
        search = null
      loadProducts(search, page)
    )
  updatePagination = (meta) ->
    total = meta.page.total
    current = meta.page.current
    for num in [1..total]
      clazz = 'not_current'
      if num == current
        clazz = 'current'
      $('.pagination').append('<a id="pagination#'+num+'" class="'+clazz+'">'+num+"</a>")


  loadProducts = (search, page) ->
    query = '/admin/products/'
    if(search != null)
      query+= '?search='+search
      previous = true
    if page!= null
      if previous
        query+= "&"
      else
        query+= "?"
      query+= "page="+page
    $.ajax(
      type: "GET",
      url: query,
      dataType: "json" 
    ).success((data) -> 
      clearField()
      products = data[0]
      meta = data[1]
      for product in products
        insertProduct(product)
      insertClear()
      updatePagination(meta)
      updateEventListener()
    );

  $('#selectProduct').click( ->
    $('#productSelectPopup').show()
    loadProducts(null,null);
  )

  $('#close_button').click( ->
    $('#productSelectPopup').hide()
  )

  $('.myprod').click( ->
    $('#productSelectPopup').show()
    loadProducts(null,null);
  )

  $('#searchbutton').click( ->
    search = $('#search').val()
    if search == ''
      search = null
    $('#search_hidden').val(search)
    loadProducts(search, null)
  )

  $('#product_auction_configuration_id').change( ->
    $(this).closest("form").submit();
  )
  
)