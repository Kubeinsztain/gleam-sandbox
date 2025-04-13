import gleam/bool
import gleam/list
import gleam/set

pub type Tree(a) {
  Nil
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Error {
  DifferentLengths
  DifferentItems
  NonUniqueItems
}

pub fn tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  use <- bool.guard(non_unique_items(inorder), Error(NonUniqueItems))
  use <- bool.guard(non_unique_items(preorder), Error(NonUniqueItems))
  use <- bool.guard(
    different_length(inorder, preorder),
    Error(DifferentLengths),
  )
  use <- bool.guard(different_items(inorder, preorder), Error(DifferentItems))

  Ok(build_tree(inorder, preorder))
}

fn non_unique_items(items: List(a)) -> Bool {
  list.length(items) != { set.from_list(items) |> set.size }
}

fn different_length(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Bool {
  list.length(inorder) != list.length(preorder)
}

fn different_items(inorder inorder: List(a), preorder preorder: List(a)) -> Bool {
  let first = set.from_list(inorder)
  let second = set.from_list(preorder)

  set.difference(first, second) |> set.size != 0
}

fn build_tree(inorder inorder: List(a), preorder preorder: List(a)) -> Tree(a) {
  use <- bool.guard(list.is_empty(preorder), Nil)

  let assert Ok(first_p) = list.first(preorder)
  let assert Ok(rest_p) = list.rest(preorder)

  let #(inorder_left, inorder_right) =
    list.split_while(inorder, different_than(first_p))
  let inorder_right = list.drop(inorder_right, 1)

  let #(preorder_left, preorder_right) =
    list.split(rest_p, list.length(inorder_left))

  Node(
    first_p,
    build_tree(inorder_left, preorder_left),
    build_tree(inorder_right, preorder_right),
  )
}

fn different_than(item: a) -> fn(a) -> Bool {
  fn(x) { x != item }
}
