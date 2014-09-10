module EntriesHelper
  def createdropdown entinst
    if !entinst.object.link_id.nil?
      entinst.collection_select(:link_id, (Entry.where(:entity_id => Entry.find(entinst.object.link_id).entity_id)).to_a, :id, :slug,  {:include_blank=>true}, {:class=>"form-control", :id=>"select"})
    else
      entinst.collection_select(:link_id, Entry.all, :id, :slug,  {:include_blank=>true}, {:class=>"form-control", :id=>"select"})
    end
  end  
end
