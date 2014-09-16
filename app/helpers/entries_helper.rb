module EntriesHelper
  
  def createdropdown entinst
    if !entinst.object.link_id.nil?
      entinst.collection_select(:link_id, (Entry.where(:entity_id => Entry.find(entinst.object.link_id).entity_id)).to_a, :id, :slug,  {:include_blank=>true}, {:class=>"form-control", :id=>"select"})
    else
      entinst.collection_select(:link_id, Entry.all, :id, :slug,  {:include_blank=>true}, {:class=>"form-control", :id=>"select"})
    end
  end  
  
  
  def create_entry_info entry
    ## Returns a set of values to create a json-ld representation of an
    ## individual entry
    
    # create a master array to contain all grouped fields
    grouped_fields = []    
    # create array to track already found field types
    fields_found = []
    
    if !entry.field_instances.empty?
      for efield in entry.field_instances
        
        if !fields_found.include?(efield.exposeAs)
          # field type has not been found as of yet so create a new hash
          field_list = {"label" => efield.exposeAs, "predicate" => (Field.find(efield.field_id)).property, "answers" => []}
          # add current answer to this grouping
          field_list["answers"] << efield.answer
          # add me as a new member of the grouped_fields master array
          grouped_fields << field_list
          # add field type to those found already (so that future instance are added to this one)
          fields_found << efield.exposeAs
        else
          # retrieve the matching existing field_list
          field_list = grouped_fields.find {|grouping| grouping["label"] == efield.exposeAs }
          # add entry mini hash to the collection
          field_list["answers"] << efield.answer          
        end
        
      end
    end
    
    # create a master array to contain all grouped entities
    grouped_entities = []    
    # create array to track already found field types
    entities_found = []
      
    if !@entry.entity_instances.empty?
      for ent in @entry.entity_instances
        
        if !entities_found.include?(ent.exposeAs)
          # entity type has not been found as of yet so create a new hash
          entity_list = {"label" => ent.exposeAs, "predicate" => ent.property, "answers" => []}
          # add current answer to this grouping
          entity_list["answers"] << ent.link_id
          # add me as a new member of the grouped_entities master array
          grouped_entities << entity_list
          # add entity type to those found already (so that future instance are added to this one)
          entities_found << ent.exposeAs
        else
          # retrieve the matching existing entity_list
          entity_list = grouped_entities.find {|grouping| grouping["label"] == ent.exposeAs }
          # add entry mini hash to the collection
          entity_list["answers"] << ent.link_id 
        end
        
      end
      
    end
    
    return grouped_fields, grouped_entities
    
  end
  
  
  def create_jsonld_entry(entity, entry, grouped_fields, grouped_entities)
    ldtext = ''
    ldtext += '{'
    ldtext += '"@id": "%s", ' % [entry_url(entry.id)]
    ldtext += '"@type": "%s", ' % [entity.typeof.to_s]
    
    fields_array = []
    grouped_fields.each do |field_group|
      field_group["answers"].each do |field|  
        fields_array << '"%s": "%s" ' % [field_group['predicate'], field]
      end
    end
    ldtext += fields_array.join(", ")
    
    answers_array = []
    # Need to add a comma if grouped entites also exist in order to make valid json     
    if !grouped_entities.empty?
      ldtext += ', '
    end
    grouped_entities.each do |entity_group|
      entity_group["answers"].each do |entity_answer|
        answers_array << '"%s": {"@id": "%s"} ' % [entity_group['predicate'], entry_url(entity_answer)]
      end
    end
    
    ldtext += answers_array.join(", ")
    ldtext += '} '
    ldtext.html_safe
  end
  
end
