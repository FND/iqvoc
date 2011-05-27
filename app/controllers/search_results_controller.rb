# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class SearchResultsController < ApplicationController
  skip_before_filter :require_user

  def index
    authorize! :read, Concept::Base

    @available_languages = (Iqvoc.available_languages + Iqvoc::Concept.labeling_class_names.values.flatten).uniq.each_with_object({}) do |lang_sym, hsh|
      lang_sym ||= "none"
      hsh[lang_sym.to_s] = t("languages.#{lang_sym.to_s}", :default => lang_sym.to_s)
    end

    # Query param tricks
    params[:type] ||= params[:t]
    params[:query] ||= params[:q]
    params[:languages] ||= params[:l]
    params[:query_type] ||= params[:qt]
    params[:collection_origin] ||= params[:c]
    request.query_parameters.delete("commit")
    request.query_parameters.delete("utf8")

    if params[:query]
      return invalid_search(I18n.t('txt.controllers.search_results.insufficient_data')) if params[:query].blank? && params[:collection_origin].blank?

      params[:languages] << nil if params[:languages].is_a?(Array) && params[:languages].include?("none")

      # Decide whether to search a specific class or ALL classes
      unless params[:type] == 'all'
        unless type_class_index = Iqvoc.searchable_class_names.map(&:parameterize).index(params[:type].parameterize)
          raise "'#{params[:type]}' is not a valid / configured searchable class! Must be one of " + Iqvoc.searchable_class_names.join(', ')
        end
        @klass = Iqvoc.searchable_class_names[type_class_index].constantize
      end

      query_size = params[:query].split(/\r\n/).size

      # handle the special case where a collection was selected but no query
      # term entered - in which case all collection members should be listed
      if not params[:query].present? and params[:collection_origin].present?
        @results = Iqvoc::Collection.base_class.
            by_origin(params[:collection_origin]).includes(:concepts).last.
            concepts.map { |c| c.pref_labelings }.flatten.
            paginate(:page => params[:page], :per_page => 50)
      # @klass is only available if we're going to search using a specific class
      # it's not available if we're searching within all classes
      elsif @klass
        if @klass.forces_multi_query? || (@klass.supports_multi_query? && query_size > 1)
          @multi_query = true
          @results = @klass.multi_query(params)
        else
          @multi_query = false
          @results = @klass.single_query(params).paginate(:page => params[:page], :per_page => 50)
        end
      else
        @multi_query = true
        logger.debug "Searching for all names"
        # all names (including collection labels)
        @results = Iqvoc.searchable_classes.
            select { |klass| (klass < Labeling::Base) }.
            map { |klass| klass.single_query(params) }.
            flatten.uniq
      end
      
      @multi_query ? logger.debug("Using multi query mode") : logger.debug("Using single query mode")

      respond_to do |format|
        format.html
        format.ttl { @multi_query ? render('search_results/unpaged/index.iqrdf') : render('search_results/paged/index.iqrdf') }
        format.rdf { @multi_query ? render('search_results/unpaged/index.iqrdf') : render('search_results/paged/index.iqrdf') }
      end

    end
  end

  protected

  def invalid_search(msg=nil)
    flash.now[:error] = msg || I18n.t('txt.controllers.search_results.query_invalid')
    render :action => 'index', :status => 422
  end

end
