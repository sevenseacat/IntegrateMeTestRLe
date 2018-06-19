// Run this example by adding <%= javascript_pack_tag "admin" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
import Elm from '../Admin/CompetitionsPage'

document.addEventListener('DOMContentLoaded', () => {
  var mountNode = document.getElementById('competitions');
  var competitionData = mountNode.getAttribute("data-competitions");
  var app = Elm.Admin.CompetitionsPage.embed(mountNode, {competitions: competitionData});
})
