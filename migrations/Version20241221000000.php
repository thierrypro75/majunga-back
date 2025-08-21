<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20241221000000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Create User and Role tables';
    }

    public function up(Schema $schema): void
    {
        // Create role table
        $this->addSql('CREATE TABLE role (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            label VARCHAR(255) NOT NULL UNIQUE,
            description VARCHAR(500) DEFAULT NULL,
            is_active BOOLEAN NOT NULL DEFAULT 1,
            created_at DATETIME NOT NULL,
            updated_at DATETIME DEFAULT NULL
        )');

        // Create user table
        $this->addSql('CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            email VARCHAR(180) NOT NULL UNIQUE,
            first_name VARCHAR(255) NOT NULL,
            last_name VARCHAR(255) NOT NULL,
            phone VARCHAR(20) DEFAULT NULL,
            is_active BOOLEAN NOT NULL DEFAULT 1,
            created_at DATETIME NOT NULL,
            updated_at DATETIME DEFAULT NULL,
            roles CLOB NOT NULL,
            password VARCHAR(255) NOT NULL
        )');

        // Create user_role table (many-to-many relationship)
        $this->addSql('CREATE TABLE user_role (
            user_id INTEGER NOT NULL,
            role_id INTEGER NOT NULL,
            PRIMARY KEY(user_id, role_id),
            FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE,
            FOREIGN KEY (role_id) REFERENCES role (id) ON DELETE CASCADE
        )');

        // Create indexes
        $this->addSql('CREATE INDEX IDX_8D93D649E7927C74 ON user (email)');
        $this->addSql('CREATE INDEX IDX_8D93D6498D93D649 ON user_role (user_id)');
        $this->addSql('CREATE INDEX IDX_8D93D649D60322AC ON user_role (role_id)');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('DROP TABLE user_role');
        $this->addSql('DROP TABLE user');
        $this->addSql('DROP TABLE role');
    }
}
