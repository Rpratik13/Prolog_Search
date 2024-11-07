% goal_state/1
goal_state(bucharest).

% Populating the Knowledge Base with each edge in graph with cost
% neighbor/3
neighbor(arad, sibiu, 140).
neighbor(arad, timisoara, 118).
neighbor(arad, zerind, 75).
neighbor(bucharest, fagaras, 211).
neighbor(bucharest, giurgiu, 90).
neighbor(bucharest, pitesti, 101).
neighbor(bucharest, urziceni, 85).
neighbor(craiova, dobreta, 120).
neighbor(craiova, pitesti, 138).
neighbor(craiova, 'rimnicu vilcea', 146).
neighbor(dobreta, craiova, 120).
neighbor(dobreta, mehadia, 75).
neighbor(eforie, hirsova, 86).
neighbor(fagaras, bucharest, 211).
neighbor(fagaras, sibiu, 99).
neighbor(giurgiu, bucharest, 90).
neighbor(hirsova, eforie, 86).
neighbor(hirsova, urziceni, 98).
neighbor(iasi, neamt, 87).
neighbor(iasi, vaslui, 92).
neighbor(lugoj, mehadia, 70).
neighbor(lugoj, timisoara, 111).
neighbor(mehadia, dobreta, 75).
neighbor(mehadia, lugoj, 70).
neighbor(neamt, iasi, 87).
neighbor(oradea, sibiu, 151).
neighbor(oradea, zerind, 71).
neighbor(pitesti, bucharest, 101).
neighbor(pitesti, craiova, 138).
neighbor(pitesti, 'rimnicu vilcea', 97).
neighbor('rimnicu vilcea', craiova, 146).
neighbor('rimnicu vilcea', pitesti, 97).
neighbor('rimnicu vilcea', sibiu, 80).
neighbor(sibiu, arad, 140).
neighbor(sibiu, fagaras, 99).
neighbor(sibiu, oradea, 151).
neighbor(sibiu, 'rimnicu vilcea', 80).
neighbor(timisoara, arad, 118).
neighbor(timisoara, lugoj, 111).
neighbor(urziceni, bucharest, 85).
neighbor(urziceni, hirsova, 98).
neighbor(urziceni, vaslui, 142).
neighbor(vaslui, iasi, 92).
neighbor(vaslui, urziceni, 142).
neighbor(zerind, arad, 75).
neighbor(zerind, oradea, 71).

% Populating the Knowledge Base with straight line distance from Bucharest to Every Node
% sld/2
sld(arad, 366).
sld(bucharest, 0).
sld(craiova, 160).
sld(dobreta, 242).
sld(eforie, 161).
sld(fagaras, 176).
sld(giurgiu, 77).
sld(hirsova, 151).
sld(iasi, 226).
sld(lugoj, 244).
sld(mehadia, 241).
sld(neamt, 234).
sld(oradea, 380).
sld(pitesti, 100).
sld('rimnicu vilcea', 193).
sld(sibiu, 253).
sld(timisoara, 329).
sld(urziceni, 80).
sld(vaslui, 199).
sld(zerind, 374).

% head/3
% Clause 1: Extract the head of a list in H and put the remaining in T
head([H | T], H, T).

% add_path_cost_to_state/4
% Clause 1: If the neighbor array is empty, nothing needs to be done.
add_path_cost_to_state(_PATH, [], _, []).

% Clause 2: Append the path to the state and cost to reach the state for each state in the array
add_path_cost_to_state([HS | TS], [H | T], COST_SO_FAR, [H2 | T2]):-
    neighbor(H, HS, COST),
    TCOST is COST + COST_SO_FAR,
    append([H, [HS | TS]], [TCOST], H2),
    add_path_cost_to_state([HS | TS], T, COST_SO_FAR, T2).

% dfs/6
% Clause 1: If the current state is the goal state, sets the path to the state and given path, cost to the state cost
% and nodes expanded to 1
dfs([STATE, PATH, COST | []], STATE, _, [STATE | PATH], COST, 1).

% Clause 2: Applies depth first search starting at current state and adding each neighbor to front of the queue and
% setting the next state to state in front of the queue
dfs([CURRENT_STATE, PATH_TO_STATE, COST_TO_STATE | []], FINAL_STATE, QUEUE, PATH, COST, NE):-
    findall(X, neighbor(CURRENT_STATE, X, _), NEIGHBORS),
    findall(Y, (member(Y, NEIGHBORS), not(member(Y, PATH_TO_STATE))), UNVISITED),
    add_path_cost_to_state([CURRENT_STATE | PATH_TO_STATE], UNVISITED, COST_TO_STATE, UNVISITED2),
    append(UNVISITED2, QUEUE, TQUEUE),
    head(TQUEUE, [NEXT_STATE, PATH_TO_STATE2, NEXT_COST | []], SQUEUE),
    dfs([NEXT_STATE, PATH_TO_STATE2, NEXT_COST], FINAL_STATE, SQUEUE, PATH, COST, RNE),
    NE is RNE + 1.


% bfs/6
% Clause 1: If the current state is the goal state, sets the path to the state and given path, cost to the state cost
% and nodes expanded to 1
bfs([STATE, PATH, COST | []], STATE, _, [STATE | PATH], COST, 1).

% Clause 2: Applies breadth first search starting at current state and adding each neighbor to back of the queue and
% setting the next state to state in front of the queue
bfs([CURRENT_STATE, PATH_TO_STATE, COST_TO_STATE | []], FINAL_STATE, QUEUE, PATH, COST, NE):-
    findall(X, neighbor(CURRENT_STATE, X, _), NEIGHBORS),
    findall(Y, (member(Y, NEIGHBORS), not(member(Y, PATH_TO_STATE))), UNVISITED),
    add_path_cost_to_state([CURRENT_STATE | PATH_TO_STATE], UNVISITED, COST_TO_STATE, UNVISITED2),
    append(QUEUE, UNVISITED2, TQUEUE),
    head(TQUEUE, [NEXT_STATE, PATH_TO_STATE2, NEXT_COST | []], SQUEUE),
    bfs([NEXT_STATE, PATH_TO_STATE2, NEXT_COST], FINAL_STATE, SQUEUE, PATH, COST, RNE),
    NE is RNE + 1.

% distance/3
% Clause 1: Sets H to the cost to reach the state and the straight line distance from state to bucharest
distance(STATE, COST_SO_FAR, H):-
    sld(STATE, S),
    H is COST_SO_FAR + S.

% add_path_heuristic_cost_to_state/4
% Clause 1: If the neighbor array is empty, nothing needs to be done.
add_path_heuristic_cost_to_state(_PATH, [], _, []).

% Clause 2: Append the path to the state, heuristic cost and actual cost to reach the state for each state in the array
add_path_heuristic_cost_to_state([HS | TS], [H | T], COST_SO_FAR, [H2 | T2]):-
    neighbor(H, HS, COST),
    TCOST is COST + COST_SO_FAR,
    distance(H, TCOST, HCOST),
    append([H, [HS | TS]], [HCOST, TCOST], H2),
    add_path_heuristic_cost_to_state([HS | TS], T, COST_SO_FAR, T2).

% swap/2
% Clause 1: Swap the first two elements if the heursitic cost of the two elements are not in ascending order
swap([[S1, P1, H1, C1], [S2, P2, H2, C2] | T], [[S2, P2, H2, C2], [S1, P1, H1, C1] | T]):-
    H2 < H1.

% Clause 2: Apply swap to the tail of the list
swap([H | T], [H | T2]):-
    swap(T, T2).

% bubble_sort/2
% Clause 1: If a swap occurs, apply bubble sort to the output of the swap
bubble_sort(L, SL):-
    swap(L, L1),
    !,
    bubble_sort(L1, SL).

% Clause 2: If no swap is required, then the list is sorted
bubble_sort(L, L).

% aStar/6
% Clause 1: If the current state is the goal state, sets the path to the state and given path, cost to the state cost
% and nodes expanded to 1
aStar([STATE, PATH, _, COST | []], STATE, _, [STATE | PATH], COST, 1).

% Clause 2: Applies A* search starting at current state and adding each neighbor to back of the queue, sorting the queue based on
% heuristic cost and setting the next state to state in front of the queue
aStar([STATE, PATH_TO_STATE, _, COST_TO_STATE | []], FINAL_STATE, QUEUE, PATH, COST, NE):-
    findall(X, neighbor(STATE, X, _), NEIGHBORS),
    findall(Y, (member(Y, NEIGHBORS), not(member(Y, PATH_TO_STATE))), UNVISITED),
    add_path_heuristic_cost_to_state([STATE | PATH_TO_STATE], UNVISITED, COST_TO_STATE, UNVISITED2),
    append(UNVISITED2, QUEUE, T_UNVISITED),
    bubble_sort(T_UNVISITED, S_UNVISITED),
    head(S_UNVISITED, [NEXT_STATE, NEXT_PATH, NEXT_HEUR_COST, NEXT_COST | []], SQUEUE),
    aStar([NEXT_STATE, NEXT_PATH, NEXT_HEUR_COST, NEXT_COST], FINAL_STATE, SQUEUE, PATH, COST, RNE),
    NE is RNE + 1.


% search/5
% Clause 1: If algorithm is dfs, apply depth first search and output path, cost and nodes expanded
search(ALGORITHM, INITIAL_STATE, PATH, COST, NODES_EXPANDED):-
    ALGORITHM = dfs,
    goal_state(GOAL_STATE),
    dfs([INITIAL_STATE, [], 0], GOAL_STATE, [], DFS_PATH, COST, NODES_EXPANDED),
    reverse(DFS_PATH, PATH).

% Clause 2: If algorithm is bfs, apply breadth first search and output path, cost and nodes expanded
search(ALGORITHM, INITIAL_STATE, PATH, COST, NODES_EXPANDED):-
    ALGORITHM = bfs,
    goal_state(GOAL_STATE),
    bfs([INITIAL_STATE, [], 0], GOAL_STATE, [], BFS_PATH, COST, NODES_EXPANDED),
    reverse(BFS_PATH, PATH).

% Clause 3: If algorithm is aStar, apply A* search and output path, cost and nodes expanded
search(ALGORITHM, INITIAL_STATE, PATH, COST, NODES_EXPANDED):-
    ALGORITHM = aStar,
    goal_state(GOAL_STATE),
    distance(INITIAL_STATE, 0, H),
    aStar([INITIAL_STATE, [], H, 0], GOAL_STATE, [], A_PATH, COST, NODES_EXPANDED),
    reverse(A_PATH, PATH).
