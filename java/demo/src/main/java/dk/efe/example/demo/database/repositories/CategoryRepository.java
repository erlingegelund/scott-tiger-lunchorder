package dk.efe.example.demo.database.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import dk.efe.example.demo.database.entities.Category;

public interface CategoryRepository extends JpaRepository<Category, Long> {}