# Gets the correct json representer for a particular data
module RepresenterFinder
  REPRESENTERS = {
    'application_record' => DataRepresenter,
    'active_record/relation' => ListRepresenter,
    'active_record/association_relation' => ListRepresenter,
    'array' => ListRepresenter,
    'tweet' => TweetRepresenter
  }

  def representer
    REPRESENTERS[data_key].new(data, options, extra_data)
  end

  private

  def data_key
    name = data.class.name.underscore
    return name if REPRESENTERS[name]

    data.class.superclass.name.underscore
  end
end
