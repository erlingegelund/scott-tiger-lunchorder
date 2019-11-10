package dk.efe.example.demo.database.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import dk.efe.example.demo.database.entities.User;

public interface UserRepository extends JpaRepository<User, Long> {
    
}