import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn insert_node(tree: Tree, data: Int) -> Tree {
  case tree {
    Nil -> Node(data, Nil, Nil)
    Node(node_data, left, right) -> {
      case data <= node_data {
        True -> Node(node_data, insert_node(left, data), right)
        False -> Node(node_data, left, insert_node(right, data))
      }
    }
  }
}

pub fn to_tree(data: List(Int)) -> Tree {
  // let reversed = list.reverse(data)
  // case reversed {
  //   [] -> Nil
  //   [x, ..rest] -> insert_node(to_tree(list.reverse(rest)), x)
  // }

  to_tree_loop(data, Nil)
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  to_tree(data) |> sort_tree
}

fn to_tree_loop(data: List(Int), tree: Tree) -> Tree {
  case data {
    [] -> tree
    [x, ..rest] ->
      insert_node(tree, x)
      |> to_tree_loop(rest, _)
  }
}

fn sort_tree(tree: Tree) -> List(Int) {
  case tree {
    Node(x, left, right) ->
      list.flatten([sort_tree(left), [x], sort_tree(right)])
    Nil -> []
  }
}
