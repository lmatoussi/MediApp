import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'password_helper.dart';
import 'patient_exercise_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    // For desktop platforms (Windows, Linux, macOS)
    String dbPath;
    
    try {
      dbPath = join(await getDatabasesPath(), 'medical_app.db');
    } catch (e) {
      // Fallback for environments where getDatabasesPath might not work
      dbPath = 'medical_app.db';
    }

    print('📱 Opening database at: $dbPath');
    
    final db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await _createDb(db, version);
        },
        onOpen: (db) async {
          await _migrateToHashedPasswords(db);
        },
      ),
    );
    
    print('✅ Database opened successfully');
    return db;
  }

  Future<void> _migrateToHashedPasswords(Database db) async {
    try {
      // Migrate admin passwords
      final admins = await db.query('admin');
      for (var admin in admins) {
        final password = admin['password'] as String?;
        // Check if password is not already hashed (hashed passwords are 64 chars)
        if (password != null && password.length < 64) {
          String hashedPassword = PasswordHelper.hashPassword(password);
          await db.update(
            'admin',
            {'password': hashedPassword},
            where: 'id = ?',
            whereArgs: [admin['id']],
          );
          print('✅ Migrated admin password for ${admin['email']}');
        }
      }

      // Migrate user passwords
      final users = await db.query('users');
      for (var user in users) {
        final password = user['password'] as String?;
        if (password != null && password.length < 64) {
          String hashedPassword = PasswordHelper.hashPassword(password);
          await db.update(
            'users',
            {'password': hashedPassword},
            where: 'id = ?',
            whereArgs: [user['id']],
          );
          print('✅ Migrated user password for ${user['email']}');
        }
      }
    } catch (e) {
      print('⚠️ Migration error: $e');
    }
  }

  Future<void> _createDb(Database db, int version) async {
    print('🔨 Creating database tables...');
    
    // Table des utilisateurs (Patients)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        date_of_birth TEXT,
        gender TEXT,
        phone TEXT,
        address TEXT,
        medical_history TEXT,
        is_active INTEGER DEFAULT 1,
        role TEXT DEFAULT 'patient',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table Admin (un seul compte)
    await db.execute('''
      CREATE TABLE admin (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        last_login TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Table des sessions d'authentification
    await db.execute('''
      CREATE TABLE auth_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        admin_id INTEGER,
        token TEXT UNIQUE NOT NULL,
        is_active INTEGER DEFAULT 1,
        expires_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(admin_id) REFERENCES admin(id)
      )
    ''');

    // Table des antécédents médicaux
    await db.execute('''
      CREATE TABLE medical_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        diagnosis TEXT,
        treatment TEXT,
        notes TEXT,
        record_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Table des exercices assignés aux patients
    await db.execute('''
      CREATE TABLE patient_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        description TEXT,
        duration INTEGER,
        sets INTEGER,
        reps INTEGER,
        assigned_date TEXT NOT NULL,
        completed INTEGER DEFAULT 0,
        completed_date TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        difficulty TEXT DEFAULT 'moyen',
        category TEXT,
        video_url TEXT,
        gif_url TEXT,
        image_path TEXT,
        muscle_groups TEXT,
        instructions TEXT,
        pain_level INTEGER,
        ai_feedback TEXT,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Table des exercices de la base (guide library)
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        difficulty TEXT NOT NULL,
        category TEXT,
        instructions TEXT,
        duration_minutes INTEGER,
        video_url TEXT,
        gif_url TEXT,
        image_path TEXT,
        ai_description TEXT,
        muscle_groups TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table exercise_progress
    await db.execute('''
      CREATE TABLE exercise_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        reps_completed INTEGER,
        duration_seconds INTEGER,
        difficulty_level TEXT,
        ai_feedback TEXT,
        pain_level INTEGER,
        date_completed TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(exercise_id) REFERENCES exercises(id)
      )
    ''');

    // Table des assessments
    await db.execute('''
      CREATE TABLE assessments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        assessment_type TEXT NOT NULL,
        score INTEGER,
        max_score INTEGER,
        date TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Créer un compte admin par défaut
    await _createDefaultAdmin(db);

    // Créer des patients de démonstration
    await _createDemoPatients(db);
    
    // Seed initial exercises
    await _seedExercises(db);
    
    print('✅ Database initialized successfully!');
  }

  Future<void> _createDefaultAdmin(Database db) async {
    try {
      await db.insert('admin', {
        'email': 'admin@medical.app',
        'password': PasswordHelper.hashPassword('Admin@2024'),
        'full_name': 'Administrator',
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('✅ Admin account created: admin@medical.app');
    } catch (e) {
      print('⚠️ Admin account already exists or error: $e');
    }
  }

  Future<void> _createDemoPatients(Database db) async {
    final demoPatients = [
      {
        'email': 'patient1@medical.app',
        'password': PasswordHelper.hashPassword('Patient@123'),
        'full_name': 'Jean Dupont',
        'date_of_birth': '1985-03-15',
        'gender': 'M',
        'phone': '+33612345678',
        'address': '123 Rue de Paris, 75000 Paris',
        'medical_history': 'Asthme léger, Allergies saisonnières',
        'is_active': 1,
        'role': 'patient',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'email': 'patient2@medical.app',
        'password': PasswordHelper.hashPassword('Patient@123'),
        'full_name': 'Marie Martin',
        'date_of_birth': '1990-07-22',
        'gender': 'F',
        'phone': '+33698765432',
        'address': '456 Avenue Montaigne, 75008 Paris',
        'medical_history': 'Diabète type 2, Hypertension',
        'is_active': 1,
        'role': 'patient',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'email': 'patient3@medical.app',
        'password': PasswordHelper.hashPassword('Patient@123'),
        'full_name': 'Pierre Bernard',
        'date_of_birth': '1978-11-05',
        'gender': 'M',
        'phone': '+33634567890',
        'address': '789 Boulevard Saint-Germain, 75006 Paris',
        'medical_history': 'Arthrite rhumatoïde, Douleurs chroniques',
        'is_active': 1,
        'role': 'patient',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var patient in demoPatients) {
      try {
        await db.insert('users', patient);
      } catch (e) {
        print('⚠️ Patient ${patient['email']} already exists');
      }
    }
    print('✅ Demo patients created');
  }

  Future<void> _seedExercises(Database db) async {
    final exercises = [
      // Facile - Cardio - Marche
      {
        'name': 'Marche en place simple',
        'description': 'Marche contrôlée en restant sur place',
        'difficulty': 'facile',
        'category': 'cardio',
        'duration_minutes': 5,
        'instructions':
          '1. Tenez-vous debout et stable\n'
          '2. Marchez lentement sur place\n'
          '3. Continuez pendant 2-3 minutes\n'
          '4. Reposez 1-2 minutes\n'
          '5. Répétez 2-3 séries',
        'muscle_groups': 'hip_flexors,quadriceps,calves,glutes',
        'gif_url': 'assets/exercises/stick_figure_walking_cycle.gif',
        'ai_description': 'Excellent pour débuter. Améliore la circulation.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Facile - Jambe - Levée assis
      {
        'name': 'Levée de jambe assis',
        'description': 'Levée de jambe simple en position assise',
        'difficulty': 'facile',
        'category': 'jambe',
        'duration_minutes': 5,
        'instructions':
          '1. Asseyez-vous confortablement\n'
          '2. Levez lentement une jambe\n'
          '3. Maintenez 2 secondes\n'
          '4. Abaissez lentement\n'
          '5. Alternez les jambes\n'
          '6. Répétez 10-12 fois',
        'muscle_groups': 'quadriceps,hip_flexors,core',
        'gif_url': 'assets/exercises/seated_leg_raise_loop.gif',
        'ai_description': 'Parfait pour renforcer les jambes. Très sûr assis.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Facile - Tronc
      {
        'name': 'Marche sur place asis avec levée de genou',
        'description': 'Simulation de marche en position assise',
        'difficulty': 'facile',
        'category': 'tronc',
        'duration_minutes': 5,
        'instructions':
          '1. Asseyez-vous droit\n'
          '2. Simulez une marche en levant les genoux\n'
          '3. Alternez les jambes rapidement\n'
          '4. Continuez pendant 2 minutes\n'
          '5. Reposez 30 secondes\n'
          '6. Répétez 3 séries',
        'muscle_groups': 'hip_flexors,core,quadriceps',
        'gif_url': 'assets/exercises/seated_marching.gif',
        'ai_description': 'Renforce les abdominaux et les fléchisseurs de hanche.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Moyen - Jambe - Sit to Stand
      {
        'name': 'Levée assis-debout assistée',
        'description': 'Passage de la position assise à debout',
        'difficulty': 'moyen',
        'category': 'jambe',
        'duration_minutes': 10,
        'instructions':
          '1. Asseyez-vous bien au fond de la chaise\n'
          '2. Penchez-vous légèrement en avant\n'
          '3. Poussez avec les jambes pour vous lever\n'
          '4. Maintenez debout 2 secondes\n'
          '5. Abaissez-vous lentement\n'
          '6. Répétez 8-10 fois\n'
          '7. Reposez 1 minute\n'
          '8. Répétez 2 séries',
        'muscle_groups': 'quadriceps,glutes,hamstrings,core',
        'gif_url': 'assets/exercises/sit_to_stand.gif',
        'ai_description': 'Essentiel pour l\'indépendance. Augmente la force des jambes.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Moyen - Équilibre
      {
        'name': 'Équilibre simple avec support',
        'description': 'Exercice d\'équilibre avec point d\'appui',
        'difficulty': 'moyen',
        'category': 'jambe',
        'duration_minutes': 5,
        'instructions':
          '1. Tenez-vous près d\'une table ou chaise\n'
          '2. Tenez le bord légèrement\n'
          '3. Tenez-vous debout sur une jambe\n'
          '4. Maintenez 20-30 secondes\n'
          '5. Changez de jambe\n'
          '6. Répétez 3-4 fois',
        'muscle_groups': 'core,glutes,ankles,proprioception',
        'gif_url': 'assets/exercises/stick_balance_loop.gif',
        'ai_description': 'Prévient les chutes. Améliore la stabilité.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Moyen - Jambe - Rotation chevilles
      {
        'name': 'Rotation des chevilles',
        'description': 'Rotations circulaires des chevilles',
        'difficulty': 'facile',
        'category': 'jambe',
        'duration_minutes': 3,
        'instructions':
          '1. Asseyez-vous confortablement\n'
          '2. Levez une jambe légèrement\n'
          '3. Faites tourner la cheville dans les deux sens\n'
          '4. 10 rotations dans chaque direction\n'
          '5. Changez de jambe\n'
          '6. Répétez 2 fois',
        'muscle_groups': 'ankles,calf,tibialis',
        'gif_url': 'assets/exercises/ankle_circle_rotation.gif',
        'ai_description': 'Améliore la flexibilité des chevilles.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Facile - Équilibre - Single Leg
      {
        'name': 'Équilibre sur une jambe',
        'description': 'Équilibre statique sur une seule jambe',
        'difficulty': 'moyen',
        'category': 'jambe',
        'duration_minutes': 5,
        'instructions':
          '1. Tenez-vous près d\'un support\n'
          '2. Soulevez une jambe\n'
          '3. Maintenez l\'équilibre pendant 20-30 secondes\n'
          '4. Reposez le pied\n'
          '5. Changez de jambe\n'
          '6. Répétez 3 fois de chaque côté',
        'muscle_groups': 'core,glutes,ankles,hip_stabilizers',
        'gif_url': 'assets/exercises/single_leg_balance_loop.gif',
        'ai_description': 'Renforce la stabilité et prévient les chutes.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Moyen - Tronc - Flexion
      {
        'name': 'Flexion progressive asise',
        'description': 'Flexion du tronc en position assise',
        'difficulty': 'moyen',
        'category': 'tronc',
        'duration_minutes': 5,
        'instructions':
          '1. Asseyez-vous droit\n'
          '2. Penchez-vous légèrement en avant\n'
          '3. Maintenez 5 secondes\n'
          '4. Revenez à la position droite\n'
          '5. Répétez 10 fois\n'
          '6. Reposez 30 secondes\n'
          '7. Répétez 2 séries',
        'muscle_groups': 'rectus_abdominis,obliques,core,back',
        'gif_url': 'assets/exercises/bed_mobility_exercise_loop.gif',
        'ai_description': 'Renforce le noyau. Améliore la mobilité.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Moyen - Cardio - Marche avec levée de genou
      {
        'name': 'Marche avec levée de genou modérée',
        'description': 'Marche avec levée active des genoux',
        'difficulty': 'moyen',
        'category': 'cardio',
        'duration_minutes': 10,
        'instructions':
          '1. Tenez-vous debout et stable\n'
          '2. Marchez lentement\n'
          '3. Levez alternativement les genoux à hauteur de hanche\n'
          '4. Continuez pendant 3-4 minutes\n'
          '5. Reposez 1-2 minutes\n'
          '6. Répétez 2-3 séries',
        'muscle_groups': 'hip_flexors,quadriceps,glutes,core',
        'gif_url': 'assets/exercises/stick_figure_walking_cycle.gif',
        'ai_description': 'Améliore la circulation et l\'endurance.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Difficile - Equilibre - Tai Chi
      {
        'name': 'Flexion des genoux style Tai Chi',
        'description': 'Flexion progressive des genoux avec équilibre',
        'difficulty': 'moyen',
        'category': 'jambe',
        'duration_minutes': 10,
        'instructions':
          '1. Tenez-vous debout, pieds écartés de la largeur des épaules\n'
          '2. Fléchissez lentement les genoux\n'
          '3. Descendez à mi-hauteur\n'
          '4. Maintenez 3 secondes\n'
          '5. Remontez lentement\n'
          '6. Répétez 8-10 fois\n'
          '7. Reposez 1 minute\n'
          '8. Répétez 2 séries',
        'muscle_groups': 'quadriceps,glutes,hamstrings,core,ankles',
        'gif_url': 'assets/exercises/tai_chi_knee_bend_loop.gif',
        'ai_description': 'Tonifie les jambes. Améliore l\'équilibre et la souplesse.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Difficile - Jambe - Escaliers
      {
        'name': 'Montée d\'escaliers assistée',
        'description': 'Montée d\'escaliers avec points d\'appui',
        'difficulty': 'difficile',
        'category': 'jambe',
        'duration_minutes': 15,
        'instructions':
          '1. Tenez la rampe ou le mur\n'
          '2. Montez une marche\n'
          '3. Amenez l\'autre jambe au même niveau\n'
          '4. Répétez 8-10 marches\n'
          '5. Reposez 2-3 minutes\n'
          '6. Redescendez lentement\n'
          '7. Répétez 2-3 séries',
        'muscle_groups': 'quadriceps,glutes,hamstrings,calves,core',
        'gif_url': 'assets/exercises/stair_climb_loop.gif',
        'ai_description': 'Exercice avancé. Augmente considérablement la force.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Facile - Mobilité - Débout
      {
        'name': 'Étirement debout simple',
        'description': 'Étirement de détente en position debout',
        'difficulty': 'facile',
        'category': 'tronc',
        'duration_minutes': 5,
        'instructions':
          '1. Tenez-vous debout, pieds écartés\n'
          '2. Levez les bras lentement vers le haut\n'
          '3. Maintez 15-20 secondes\n'
          '4. Baissez les bras\n'
          '5. Penchez-vous légèrement sur les côtés\n'
          '6. Maintenez 15 secondes de chaque côté',
        'muscle_groups': 'deltoid,back,core,hamstrings',
        'gif_url': 'assets/exercises/standing_stretch_loop.gif',
        'ai_description': 'Excellent pour l\'assouplissement général.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      // Difficile - Mobilité - Marche avec aide
      {
        'name': 'Marche avec déambulateur ou canne',
        'description': 'Marche sécurisée avec aide à la mobilité',
        'difficulty': 'moyen',
        'category': 'cardio',
        'duration_minutes': 10,
        'instructions':
          '1. Tenez fermement le déambulateur ou la canne\n'
          '2. Avancez d\'un pas\n'
          '3. Avancez l\'équipement\n'
          '4. Répétez lentement et régulièrement\n'
          '5. Marchez 5-10 minutes\n'
          '6. Reposez 1-2 minutes\n'
          '7. Répétez 2 séries',
        'muscle_groups': 'hip_flexors,quadriceps,glutes,calves,core',
        'gif_url': 'assets/exercises/walker_stick_figure_loop.gif',
        'ai_description': 'Très utile pour la rééducation en toute sécurité.',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var exercise in exercises) {
      try {
        await db.insert('exercises', exercise);
      } catch (e) {
        print('⚠️ Exercise ${exercise['name']} already exists: $e');
      }
    }
    print('✅ Exercises seeded successfully with GIF guides!');
  }

  // =============== DEBUG: Afficher la BD ===============
  
  Future<void> debugPrintDatabase() async {
    final db = await database;
    
    print('\n\n╔═══════════════════════════════════════════╗');
    print('║        DATABASE DEBUG - ADMIN TABLE       ║');
    print('╚═══════════════════════════════════════════╝');
    
    final admins = await db.query('admin');
    if (admins.isEmpty) {
      print('❌ NO ADMIN FOUND!');
    } else {
      for (var admin in admins) {
        print('\n✅ ADMIN ACCOUNT:');
        print('   Email: ${admin['email']}');
        print('   Password: ${admin['password']}');
        print('   Active: ${admin['is_active']}');
      }
    }
    
    print('\n╔═══════════════════════════════════════════╗');
    print('║         DATABASE DEBUG - USERS TABLE      ║');
    print('╚═══════════════════════════════════════════╝');
    
    final users = await db.query('users');
    if (users.isEmpty) {
      print('❌ NO USERS FOUND!');
    } else {
      for (var user in users) {
        print('\n✅ USER:');
        print('   Email: ${user['email']}');
        print('   Name: ${user['full_name']}');
        print('   Password: ${user['password']}');
      }
    }
    print('\n');
  }

  // =============== MÉTHODES LOGIN ===============
  
  Future<Map<String, dynamic>?> loginPatient(String email, String password) async {
    final db = await database;
    print('🔍 Attempting patient login: $email / $password');
    
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND is_active = 1',
      whereArgs: [email],
    );
    
    if (result.isNotEmpty) {
      final storedPassword = result.first['password'] as String?;
      if (storedPassword != null && PasswordHelper.verifyPassword(password, storedPassword)) {
        print('✅ Patient login SUCCESS');
        return result.first;
      }
    }
    print('❌ Patient login FAILED');
    return null;
  }

  Future<Map<String, dynamic>?> loginAdmin(String email, String password) async {
    final db = await database;
    print('🔍 Attempting ADMIN login: $email / $password');
    
    final List<Map<String, dynamic>> result = await db.query(
      'admin',
      where: 'email = ? AND is_active = 1',
      whereArgs: [email],
    );
    
    if (result.isNotEmpty) {
      final storedPassword = result.first['password'] as String?;
      if (storedPassword != null && PasswordHelper.verifyPassword(password, storedPassword)) {
        print('✅ ADMIN login SUCCESS');
        return result.first;
      }
    }
    print('❌ ADMIN login FAILED');
    return null;
  }

  Future<int> registerPatient(Map<String, dynamic> patient) async {
    final db = await database;
    return await db.insert('users', {
      ...patient,
      'password': PasswordHelper.hashPassword(patient['password']),
      'is_active': 1,
      'role': 'patient',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final db = await database;
    return await db.query('users', where: 'role = ?', whereArgs: ['patient']);
  }

  // =============== MÉTHODES DOSSIERS MÉDICAUX ===============
  
  Future<int> addMedicalRecord(int userId, Map<String, dynamic> record) async {
    final db = await database;
    return await db.insert('medical_records', {
      ...record,
      'user_id': userId,
      'record_date': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMedicalRecords(int userId) async {
    final db = await database;
    return await db.query(
      'medical_records',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'record_date DESC',
    );
  }

  // =============== MÉTHODES EXERCICES ===============
  
  Future<int> assignExercise(int userId, Map<String, dynamic> exercise) async {
    final db = await database;
    return await db.insert('patient_exercises', {
      ...exercise,
      'user_id': userId,
      'assigned_date': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPatientExercises(int userId) async {
    final db = await database;
    return await db.query(
      'patient_exercises',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'assigned_date DESC',
    );
  }

  Future<void> markExerciseCompleted(int exerciseId) async {
    final db = await database;
    await db.update(
      'patient_exercises',
      {
        'completed': 1,
        'completed_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [exerciseId],
    );
  }

  // =============== NEW EXERCISE METHODS ===============

  /// Get all exercises
  Future<List<PatientExercise>> getAllExercises() async {
    final db = await database;
    final results = await db.query('patient_exercises');
    return results.map((map) => PatientExercise.fromMap(map)).toList();
  }

  /// Get exercises by difficulty
  Future<List<PatientExercise>> getExercisesByDifficulty(String difficulty) async {
    final db = await database;
    final results = await db.query(
      'patient_exercises',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
    );
    return results.map((map) => PatientExercise.fromMap(map)).toList();
  }

  /// Get exercises by category
  Future<List<PatientExercise>> getExercisesByCategory(String category) async {
    final db = await database;
    final results = await db.query(
      'patient_exercises',
      where: 'category = ?',
      whereArgs: [category],
    );
    return results.map((map) => PatientExercise.fromMap(map)).toList();
  }

  /// Record exercise progress
  Future<int> recordExerciseProgress({
    required int userId,
    required int exerciseId,
    required int repsCompleted,
    required int durationSeconds,
    required int painLevel,
    String? aiFeedback,
  }) async {
    final db = await database;
    return await db.insert('exercise_progress', {
      'user_id': userId,
      'exercise_id': exerciseId,
      'reps_completed': repsCompleted,
      'duration_seconds': durationSeconds,
      'pain_level': painLevel,
      'ai_feedback': aiFeedback,
      'date_completed': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get user exercise progress
  Future<List<Map<String, dynamic>>> getUserExerciseProgress(int userId) async {
    final db = await database;
    return await db.query(
      'exercise_progress',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date_completed DESC',
    );
  }

  /// Update exercise with new fields
  Future<int> updateExercise(int exerciseId, Map<String, dynamic> updates) async {
    final db = await database;
    return await db.update(
      'patient_exercises',
      updates,
      where: 'id = ?',
      whereArgs: [exerciseId],
    );
  }
}

