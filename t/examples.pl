:- use_module(library(mustache)).

{|mustache(hello)||Hello world!|}.

:- use_module(library(tap)).

just_text :-
    phrase(hello(_), Hello),
    Hello == `Hello world!`.
