#!/bin/bash

# Script per commit automatici rapidi
# Uso: ./git-quick.sh "messaggio del commit"

# Colori per output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Git Quick Commit Script${NC}"
echo "================================"

# Controlla se siamo in un repo git
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Errore: Non sei in una directory git!${NC}"
    exit 1
fi

# Ottieni il branch corrente
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

echo -e "${YELLOW}📍 Branch corrente: ${GREEN}$CURRENT_BRANCH${NC}"

# Controlla lo stato
git status --porcelain > /dev/null
if [ $? -eq 0 ]; then
    CHANGES=$(git status --porcelain | wc -l)
    if [ $CHANGES -eq 0 ]; then
        echo -e "${YELLOW}✨ Nessuna modifica da committare${NC}"
        exit 0
    fi
    echo -e "${GREEN}📝 Modifiche trovate: $CHANGES file(s)${NC}"
else
    echo -e "${RED}❌ Errore nel controllare lo stato git${NC}"
    exit 1
fi

# Messaggio del commit
if [ -z "$1" ]; then
    echo -e "${YELLOW}💬 Inserisci il messaggio del commit:${NC}"
    read -p "> " COMMIT_MESSAGE
else
    COMMIT_MESSAGE="$1"
fi

# Se il messaggio è vuoto, usa uno predefinito
if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="🔄 Quick update - $(date '+%Y-%m-%d %H:%M')"
fi

echo -e "${YELLOW}📝 Messaggio del commit: ${GREEN}$COMMIT_MESSAGE${NC}"

# Esegui i comandi git
echo -e "${YELLOW}🔄 Eseguendo git add...${NC}"
git add .

echo -e "${YELLOW}💾 Eseguendo git commit...${NC}"
git commit -m "$COMMIT_MESSAGE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Commit eseguito con successo!${NC}"
    
    # Chiedi se fare push
    echo -e "${YELLOW}🚀 Vuoi fare push su $CURRENT_BRANCH? (y/n)${NC}"
    read -p "> " PUSH_CONFIRM
    
    if [ "$PUSH_CONFIRM" = "y" ] || [ "$PUSH_CONFIRM" = "Y" ] || [ "$PUSH_CONFIRM" = "yes" ]; then
        echo -e "${YELLOW}📤 Eseguendo git push...${NC}"
        git push origin "$CURRENT_BRANCH"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}🎉 Push completato con successo!${NC}"
            echo -e "${GREEN}💚 I tuoi bollini verdi sono al sicuro!${NC}"
        else
            echo -e "${RED}❌ Errore durante il push${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⏸️  Push saltato. Ricorda di fare push quando sei pronto!${NC}"
    fi
else
    echo -e "${RED}❌ Errore durante il commit${NC}"
    exit 1
fi

echo -e "${GREEN}✨ Operazione completata!${NC}"
