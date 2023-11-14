% Copyright

implement main
    open core, stdio, file

domains
    client_status = bronze; gold; silver.
    gender = male; female.
    str_type = string.
    int_type = integer.

class facts - projectDb
    s : (real Sum) single.
    s1 : (real Sum) single.
    tovar : (int_type Id, str_type Name, str_type Category, real Price) nondeterm.
    client : (str_type Name, str_type Telephone, gender Gender, client_status Client_Status) nondeterm.
    sales : (str_type Telephone, int_type Id, int_type Количество, int_type Day, str_type Month) nondeterm.

class predicates
    sum_sales : (int_type D, str_type M) determ.
    sales_by : (str_type Num, str_type Tovar [out], int_type Purchased [out]) nondeterm.
    who_bought : (int_type Id, str_type Person [out], str_type Ti [out]) nondeterm.
    customer_gender : (int_type Id, gender Gender [out]) nondeterm.
    goods_sold_on : (int_type Day, str_type Month) nondeterm.
    total_income_on : (int_type D, str_type M).

clauses
    s(0).
    s1(0).
    sum_sales(D, M) :-
        sales(_, _, Sale, D, M),
        s(Sum),
        asserta(s(Sum + Sale)),
        fail.

    sum_sales(D, M) :-
        sales(_, _, _, D, M),
        s(Sum),
        write("Sum of sale is ", Sum),
        nl,
        !.
    sales_by(Num, Tovar, Purchased) :-
        sales(Num, Id, Purchased, _, _),
        tovar(Id, Tovar, _, _).

    who_bought(Id, Person, Ti) :-
        sales(Num, Id, _, _, _),
        client(Person, Num, _, _),
        tovar(Id, Ti, _, _).

    customer_gender(Id, Gender) :-
        sales(Num, Id, _, _, _),
        client(_, Num, Gender, _).

    goods_sold_on(Day, Month) :-
        sales(_, Id, _, Day, Month),
        tovar(Id, Good, _, _),
        write("Goods sold on ", Day, " ", Month, " is ", Good).

    total_income_on(D, M) :-
        sales(_, Id, Quant, D, M),
        tovar(Id, _, _, Price),
        Sales = Price * Quant,
        s1(Sum),
        asserta(s1(Sum + Sales)),
        fail.

    total_income_on(D, M) :-
        s1(Sum),
        write("\nTotal income for ", D, "/", M, " is: ", Sum),
        nl,
        !.

clauses
    run() :-
        consult("../database.txt", projectDb),
        fail.
        /*run() :-
        tovar(A, B, C, D),
        write("tovar with Id ", A, " is ", B, " from the class of  ", C, " and the price is ", D),
        nl,
        fail.*/
    run() :-
        sum_sales(5, "May"),
        nl,
        fail.
    run() :-
        sales_by("89015467856", Good, Quantity),
        write(Good, " купил ", Quantity, " раз"),
        nl,
        fail.
        %whitespace
    run() :-
        write("\n"),
        write("\n"),
        fail.
    run() :-
        who_bought(4, Name, Good),
        write(Good, " bought by : ", Name),
        nl,
        fail.
        %whitespace
    run() :-
        write("\n"),
        write("\n"),
        fail.
    run() :-
        customer_gender(7, Gender),
        write("Gender = ", Gender),
        nl,
        fail.
    run() :-
        write("\n"),
        write("\n"),
        fail.
    run() :-
        goods_sold_on(5, "May"),
        nl,
        fail.
    run() :-
        total_income_on(5, "May"),
        nl,
        fail.
    run().

end implement main

goal
    console::runUtf8(main::run).
