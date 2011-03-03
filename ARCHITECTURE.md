Introduction and Goals
======================

iQvoc is a web-based vocabulary management framework which provides an
intuitive user interface while Semantic Web interoperability.

iQvoc supports vocabularies that are common to many knowledge organization
systems, such as:

* Thesauri
* Taxonomies
* Classification schemes
* Subject heading systems

iQvoc provides comprehensive functionality for all aspects of managing such
vocabularies:

* multilingual display and navigation in any Web browser
* editorial control for approved versions
* publishing the vocabulary in the Semantic Web
* easy customization according to users' needs
* import of existing vocabularies from a SKOS representation


Context
=======

iQvoc is actively being developed by innoQ[ownership is evil?] and is being
employed in a variety of diverse[?] projects.


Infrastructure
==============

based on Ruby on Rails, compatible with a variety of SQL databases


Web API
=======

[not designed to be used by alternative clients, yet?]

Resources
---------

/<language>

    /concepts
        /<ID>
    /labels
        /<ID>
    /collections
    /user_session
        POST  log in

/search
/schema


Representations
---------------

* HTML
* RDF/XML
* [Turtle](http://www.w3.org/TeamSubmission/turtle/ "Terse RDF Triple Language")


Models
======

iQvoc's basic models are based on
[SKOS](http://www.w3.org/TR/skos-reference/ "Simple Knowledge Organization System"),
providing two main constructs: concepts and labels. A concept represents an
abstract notion, labels constitute terms which provide a natural-language
representation of concepts.

Each concept may have a preferred label per language, as well as any number of
alternative terms or synonyms. It can be described by a variety of notes and
external references (matches).

Concepts can be arranged in hierarchies, described by a variety of notes, and
each concept .

High-level Overview
-------------------

                                          n .. 1
      +-----------------------------------------------------------------------------+
      v                                                                             v
    +------------+   n .. 1   +--------------+   n .. m   +----------+   n .. m   +--------------+
    |    Note    | <--------> |              | <--------> | Labeling | <--------> |    Label     |
    +------------+            |              |            +----------+            +--------------+
                              |              |                                      ^          ^
                              |   Concept    |                                      +----------+
                              |              |                                        relation
    +------------+   n .. m   |              |   1 .. n   +----------+
    | Collection | <--------> |              | <--------> |  Match   |
    +------------+            +--------------+            +----------+
      ^        ^                ^          ^
      +--------+                +----------+
        n .. m                    relation

(generated with graph-easy from diagrams/main.txt)


Components
==========

iQvoc makes use of Rails Engines to provide extensibility and reuse. Individual
projects can make use of the iQvoc framework and customize default settings by
extending the Iqvoc module (lib/iqvoc.rb).


User Roles
==========

* guests (anonymous users) can navigate, search and view all published entries
* readers can view private revisions which have not yet been published
* editors can create or modify entries, proposing updates for publication
* publishers, in addition to having editor privileges, can publish
  modifications and unlock entries
* administrators, in addition to having publisher privileges, can modify user
  privileges


Interaction Flow
================

Editing and Publication
-----------------------

* when viewing an individual concept or label, editors can choose to edit the
  respective entry by creating a new version - alternatively, new entries can
  be created via the user's dashboard
* creating a new version creates a private revision and locks the entry,
  preventing simultaneous edits by other users
* after editing an entry, the editor can propose the changes for publication
* proposed changes appear in publishers' dashboard, where they can be reviewed
  and publication can be approved
* upon publication, the updated version replaces the public version


Import
------

Since there is no generic RDF import mechanism yet, projects currently provide
their own import scripts. This is typically implemented as a Rake task (e.g.
lib/tasks/import.rake; `rake iqvoc_spez:import:file FILE=data.nt`).


Process Flow
============


Deployment
==========

[any number of possibilities; it's just a framework]


Glossary
========
