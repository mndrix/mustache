:- module(mustache, [mustache/4]).
:- use_module(library(dcg/basics)).
:- use_module(library(list_util)).

:- quasi_quotation_syntax(mustache).


template([Tag|Template],Dot) -->
    tag(Tag,Dot),
    template(Template,Dot).
template([Static|Template],Dot) -->
    static(Static),
    template(Template,Dot).
template([],_Dot) -->
    "".

open_tag -->
    "{{".


close_tag -->
    "}}".


tag(escaped(Dot,Key),Dot) -->
    open_tag,
    string_without(`}`, KeyCodes),
    { atom_codes(Key,KeyCodes) },
    close_tag.


static([C|Cs]) -->
    \+ open_tag,
    [C],
    static_rest(Cs).

static_rest([C|Cs]) -->
    \+ open_tag,
    [C],
    static_rest(Cs).
static_rest([]) -->
    \+ [_].
static_rest([]) -->
    \+ \+ open_tag,
    "".


mustache(Content,[Functor],_VarNames,Dcg) :-
    phrase_from_quasi_quotation(template(T,Dot),Content),
    Head =.. [Functor,Dot],
    xfy_list((,),Body,T),
    Dcg = ( Head --> Body ).


{|mustache(howdy)||Hello {{whom}}!|}.
