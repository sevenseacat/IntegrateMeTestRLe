// Run this example by adding <%= javascript_pack_tag "admin" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
import Elm from '../Admin/Main.elm'

document.addEventListener('DOMContentLoaded', () => {
  var mountNode = document.getElementById('competitions');
  if(mountNode) {
    var competitionData = mountNode.getAttribute("data-competitions");
    var listData = mountNode.getAttribute("data-mailing-lists");
    var app = Elm.Admin.Main.embed(mountNode, {competitions: competitionData, mailingLists: listData});
  }
})
