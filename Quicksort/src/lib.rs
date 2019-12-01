//! # Quicksort
//!
//! This is a quicksort implementation https://algs4.cs.princeton.edu/23quicksort/
//! that takes the median value of three random index points in the collection
//! and used that value for the initial pivot value to help avoid worst case scenarios.

extern crate rand;

pub mod uniq_vec;
pub mod quicksort;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_quicksort() {
        let mut sort_vec = vec![10, 20, 5, 300, 176];
        quicksort::quicksort(&mut sort_vec);
        assert_eq!(sort_vec, vec![5, 10, 20, 176, 300]);
    }
}
